//
//  GameDetailReactor.swift
//  GameStarDB
//
//  Created by Roman on 30.07.2020.
//  Copyright © 2020 Roman Osadchuk. All rights reserved.
//

import RxSwift
import RxCocoa
import RxFlow
import RxSwiftExt
import ReactorKit
import struct Differentiator.SectionModel

final class GameDetailReactor: Reactor {

    typealias SectionType = SectionModel<String, String>

    enum Action: Equatable {}

    enum Mutation: Equatable {
        case itemsLoaded([URL])
        case errorOccured(String)
    }

    struct State {
        var item: GameListItem
        var isLoading = false
        var items = [URL]()
        var text: String { item.summary ?? "" }
        var dataSource: [SectionType] {
            var screenshotsUrls = item.screenshots?.map({ $0.url }) ?? [String]()
            item.cover.flatMap { screenshotsUrls.append($0.url) } // Append cover to screenshots
            return [SectionModel(model: "", items: screenshotsUrls)]
        }
    }

    let steps = PublishRelay<Step>()

    let initialState: State

    init(item: GameListItem) {
        self.initialState = State(item: item)
    }

    func mutate(action: Action) -> Observable<Mutation> { Observable.never() }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {

        case .itemsLoaded(let items):
            newState.items = items

        case .errorOccured(let error):
            print(error)
        }

        return newState
    }
}

