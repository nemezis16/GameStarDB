//
//  Response.swift
//  GameStarDB
//
//  Created by Roman on 04.04.2020.
//  Copyright © 2020 Roman Osadchuk. All rights reserved.
//

struct Response<Item: Decodable> {
    let items: [Item]
}

// MARK: - Decodable
extension Response: Decodable {
}
