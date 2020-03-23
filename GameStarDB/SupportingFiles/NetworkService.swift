//
//  NetworkService.swift
//  GameStarDB
//
//  Created by Roman Osadchuk on 07.01.2020.
//  Copyright © 2020 Roman Osadchuk. All rights reserved.
//

import Foundation   
import SwiftyJSON
import Moya

enum ApiResult {
    case success(JSON)
    case failure(RequestError)
}

enum RequestError: Error {
      case unknownError
      case connectionError
      case authorizationError(JSON)
      case invalidRequest
      case notFound
      case invalidResponse
      case serverError
      case serverUnavailable
}

class NetworkService {
    
    static let shared = NetworkService()

    private let provider = MoyaProvider<IGDB>()

    public func request(target: IGDB, completion: @escaping (ApiResult)->Void) {
        provider.request(target) { result in
            switch result {
            case .success(let result): do {
                let responseJson = try JSON(data: result.data)
                    print("responseCode : \(result.statusCode)")
                    print("responseJSON : \(responseJson)")
                    switch result.statusCode {
                    case 200:
                    completion(ApiResult.success(responseJson))
                    case 400...499:
                    completion(ApiResult.failure(.authorizationError(responseJson)))
                    case 500...599:
                    completion(ApiResult.failure(.serverError))
                    default:
                        completion(ApiResult.failure(.unknownError))
                        break
                    }
                } catch let parseJSONError {
                    completion(ApiResult.failure(.unknownError))
                    print("error on parsing request to JSON : \(parseJSONError)")
                }
            case .failure(let error):
                completion(ApiResult.failure(.connectionError))
                print("\(error.localizedDescription)")
            }
        }
    }
}
