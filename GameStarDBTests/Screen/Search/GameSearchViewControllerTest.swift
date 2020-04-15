//
//  GameSearchViewControllerTests.swift
//  GameStarDBTests
//
//  Created by Roman on 15.04.2020.
//  Copyright © 2020 Roman Osadchuk. All rights reserved.
//

import Nimble
import Quick
import RxSwift
@testable import GameStarDB
import RxTest

final class GameSearchViewControllerTest: QuickSpec {
    override func spec() {
        super.spec()

        describe("GameSearchViewController memory leaks test") {
            it("should release RxSwift.Resources after deinit") {
                let expectedTotal = Resources.total
                autoreleasepool {
                    let sut = GameSearchViewController.instantiate()
                    let searchService = SearchServiceImpl(jsonDecoder: JSONDecoder(), backgroundScheduler: MainScheduler.instance)
                    sut.reactor = GameSearchViewModel(searchService: searchService)

                    _ = sut.view
                }
                expect(Resources.total).toEventually(equal(expectedTotal))
            }
        }
    }
}
