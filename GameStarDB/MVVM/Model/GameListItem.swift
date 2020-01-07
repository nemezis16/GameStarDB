//
//  GameListItem.swift
//  GameStarDB
//
//  Created by Roman Osadchuk on 06.01.2020.
//  Copyright © 2020 Roman Osadchuk. All rights reserved.
//

import Foundation

// MARK: - GameListItem
struct GameListItem: Codable {
    let id: Int
    let cover: Cover?
    var genres: [Genre]?
    let name: String
    let rating: Double?
}

// MARK: - Cover
struct Cover: Codable {
    let id: Int
    let alphaChannel, animated: Bool?
    let game, height: Int
    let imageID, url: String
    let width: Int

    enum CodingKeys: String, CodingKey {
        case id
        case alphaChannel = "alpha_channel"
        case animated, game, height
        case imageID = "image_id"
        case url, width
    }
}

// MARK: - Genre
struct Genre: Codable {
    let id: Int
    let name: String
}

// MARK: Convenience initializers

extension GameListItem {
    init?(data: Data) {
        do {
            let me = try JSONDecoder().decode(GameListItem.self, from: data)
            self = me
        } catch {
            print(error)
            return nil
        }
    }
}
