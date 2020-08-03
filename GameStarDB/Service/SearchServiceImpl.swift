//
//  SearchServiceImpl.swift
//  GameStarDB
//
//  Created by Roman on 04.04.2020.
//  Copyright © 2020 Roman Osadchuk. All rights reserved.
//

import class Foundation.JSONDecoder
import struct RxSwift.Single
import protocol RxSwift.SchedulerType
import RxCocoa
import Moya

final class SearchServiceImpl: SearchService {
    private let jsonDecoder: JSONDecoder
    private let backgroundScheduler: SchedulerType
    private let provider = MoyaProvider<IGDB>(plugins: [NetworkLoggerPlugin(configuration: .init( logOptions: .successResponseBody))])
    var page: Page = .first

    init(jsonDecoder: JSONDecoder, backgroundScheduler: SchedulerType) {
        self.jsonDecoder = jsonDecoder
        self.backgroundScheduler = backgroundScheduler
    }

    func search(query: String, page: Page) -> Single<[GameListItem]> {
        let request = IGDB.search(query: query, limit: page.limit, offset: page.offset)
        return provider.rx.request(request)
            .subscribeOn(backgroundScheduler)
            .map { [jsonDecoder] in try jsonDecoder.decode([GameListItem].self, from: $0.data)
        }
    }
}
