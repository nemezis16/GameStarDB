//
//  IGDB.swift
//  GameStarDB
//
//  Created by Roman Osadchuk on 05.01.2020.
//  Copyright © 2020 Roman Osadchuk. All rights reserved.
//

import Foundation
import Moya

let searchLimit = 20
let searchOffset = 0

enum IGDB {
    
    case search(query: String, limit: Int? = searchLimit, offset: Int? = searchOffset)
    
}

extension IGDB: TargetType {
    var baseURL: URL {
           return URL(string: "https://api-v3.igdb.com")!
    }
       
    var path: String {
       switch self {
       case .search:
            return "/games"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .search:
            return .post
        }
    }
       
    var task: Task {
        switch self {
        case .search(let query, let limit, let offset):
            let parameters = ["search": query,
                              "fields": "name, cover.*, rating, genres.name",
                               "limit": "\(limit ?? searchLimit)",
                              "offset": "\(offset ?? searchOffset)"]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        }
    }
        
    var sampleData: Data {
        switch self {
        case .search(name: _):
            return "Half measures are as bad as nothing at all.".data(using: .utf8)!
        }
    }
        
    var headers: [String: String]? {
        return ["user-key": "97ec8abb3eca0dfc172f166746cff36a"]
    }
}
