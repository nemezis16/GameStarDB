//
//  SearchService.swift
//  GameStarDB
//
//  Created by Roman on 04.04.2020.
//  Copyright © 2020 Roman Osadchuk. All rights reserved.
//

import struct RxSwift.Single

protocol SearchService {
    func search(query: String, page: Page) -> Single<[GameListItem]>
}

