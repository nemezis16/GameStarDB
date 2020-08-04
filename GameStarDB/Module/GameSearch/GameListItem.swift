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
    let name: String
    let summary: String?
    let genres: [Genre]?
    let rating: Double?
    let screenshots: [Cover]?
}

// MARK: - Equatable
extension GameListItem: Equatable {
    static func == (lhs: GameListItem, rhs: GameListItem) -> Bool { lhs.id == rhs.id }
}

// MARK: - Cover
struct Cover: Codable {
    let id: Int
    let width: Int
    let game: Int
    let height: Int
    let imageId: String?
    let url: String
    let animated: Bool?
    let alphaChannel: Bool?

    enum CodingKeys: String, CodingKey {
        case id
        case animated
        case game
        case height
        case url
        case width
        case alphaChannel
        case imageId
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
