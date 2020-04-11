//
//  NetworkService.swift
//  GameStarDB
//
//  Created by Roman Osadchuk on 07.01.2020.
//  Copyright © 2020 Roman Osadchuk. All rights reserved.
//

//import Foundation   
//import Moya
//import RxSwift
//
//enum ApiResult {
//    case success(JSON)
//    case failure(RequestError)
//}
//
//enum RequestError: Error {
//      case unknownError(String? = nil)
//      case connectionError
//      case authorizationError(JSON)
//      case invalidRequest
//      case notFound
//      case invalidResponse
//      case serverError
//      case serverUnavailable
//}
//
//
//class NetworkService: ReactiveCompatible {
//    static let shared = NetworkService()
//    let provider = MoyaProvider<IGDB>()
//}
//
//extension Reactive where Base: NetworkService {
//    
//    func request(target: IGDB) -> Observable<ApiResult> {
//        return Observable.create { [weak base] observer -> Disposable in
//
//            let observable = base?.provider.rx.requestWithProgress(target).subscribe { event in
//                switch event {
//                case .next(let progressResponse):
//                    if let response = progressResponse.response {
//                        do {
//                        let responseJson = try JSON(data: response.data)
//                            print("responseCode : \(response.statusCode)")
//                            print("responseJSON : \(responseJson)")
//
//                            switch response.statusCode {
//                            case 200:
//                                observer.onNext(.success(responseJson))
//
//                            case 400...499:
//                                observer.onNext(.failure(.authorizationError(responseJson)))
//
//                            case 500...599:
//                                observer.onNext(.failure(.serverError))
//
//                            default:
//                                observer.onNext(.failure(.unknownError(responseJson.description)))
//                                break
//                            }
//                            observer.onCompleted()
//                        } catch let parseJSONError {
//                            observer.onError(parseJSONError)
//                            print("error on parsing request to JSON : \(parseJSONError)")
//                        }
//                    } else {
//                        print("Progress: \(progressResponse.progress)")
//                    }
//
//                case .error(let error):
//                    observer.onError(error)
//
//                case .completed: break
//                }
//            }
//
//            return Disposables.create { observable?.dispose() }
//        }
//    }
//}
