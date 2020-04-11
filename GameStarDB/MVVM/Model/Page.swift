//
//  Page.swift
//  GameStarDB
//
//  Created by Roman on 09.04.2020.
//  Copyright © 2020 Roman Osadchuk. All rights reserved.
//

struct Page {
    let limit: Int = 20
    var offset: Int = 0
}

extension Page {
    static var first: Page { Page() }
    var isFirst: Bool {  offset == 0 }
    var next: Page {  Page(offset: offset + limit) }
}
