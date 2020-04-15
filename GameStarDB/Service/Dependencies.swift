//
//  Dependencies.swift
//  GameStarDB
//
//  Created by Roman on 04.04.2020.
//  Copyright © 2020 Roman Osadchuk. All rights reserved.
//

import class Foundation.JSONDecoder
import class RxSwift.SerialDispatchQueueScheduler

/// There is no place for production-like DI in this example, sorry
enum Dependencies {
    static let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    static let backgroundScheduler = SerialDispatchQueueScheduler(qos: .userInitiated)
    static let searchService = SearchServiceImpl(jsonDecoder: jsonDecoder, backgroundScheduler: Dependencies.backgroundScheduler)
    static let searchViewModel2 = GameSearchViewModel(searchService: searchService)
}
