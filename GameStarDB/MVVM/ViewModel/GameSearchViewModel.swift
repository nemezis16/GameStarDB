//
//  GameSearchViewModel.swift
//  GameStarDB
//
//  Created by Roman Osadchuk on 06.01.2020.
//  Copyright © 2020 Roman Osadchuk. All rights reserved.
//

import RxSwift
import RxSwiftExt
import ReactorKit
import struct Differentiator.SectionModel

class GameSearchViewModel {
    
    public enum SearchError {
        case internetError(String)
        case serverMessage(String)
    }

    public let gameList : PublishSubject <[GameListItem]> = PublishSubject()
    public let loading : PublishSubject <Bool> = PublishSubject()
    public let error : PublishSubject<SearchError> = PublishSubject()

    private let disposableBug = DisposeBag()
    
    public func requestData(data: String) {



//        self.loading.onNext(true)

//        NetworkService.shared.rx.request(target: .search(query: "Potter" )).subscribe(onNext: { result in
//            switch result {
//            case .success(let returnJson) :
//                let gameList = returnJson.arrayValue.compactMap { return GameListItem(data: try! $0.rawData())}
//                self.gameList.onNext(gameList)
//            case .failure(let failure) :
//                switch failure {
//                case .connectionError:
//                    self.error.onNext(.internetError("Check your Internet connection."))
//                case .authorizationError(let errorJson):
//                    self.error.onNext(.serverMessage(errorJson["message"].stringValue))
//                default:
//                    self.error.onNext(.serverMessage("Unknown Error"))
//                }
//            }
//        }, onError: { error in
//            self.error.onNext(.serverMessage(error.localizedDescription))
//        }).disposed(by: disposableBug)
    }
}


final class GameSearchViewModel2: Reactor {
    typealias SectionType = SectionModel<String, GameListItem>

    enum Action: Equatable {
        case search(String)
        case selecteItem(GameListItem)
        case reachedBottom
    }

    enum Mutation {
        case itemsLoaded([GameListItem])
        case itemsAppended([GameListItem])
        case toggleLoading(Bool)
        case errorOccurred(String)
        case pageUpdated(searchQuery: String, page: Page)
    }

    struct State {
        var searchQuery = ""
        var page = Page.first
        var isLoading = false
        var items = [GameListItem]()
    }

    var initialState = State()

    private let searchService: SearchService

    init(searchService: SearchService) {
        self.searchService = searchService
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .selecteItem(let item):
            print("Item selected: \(item)")
            return .empty()

        case .reachedBottom:
            let query = currentState.searchQuery
            let page = currentState.page.next
            let searchEvents = searchService.search(query: query, page: page).asObservable().materialize().share()
            //Materialize into Success events and Error events
            let successEvents = Observable.concat( searchEvents.elements() .map(Mutation.itemsAppended), .just(.pageUpdated(searchQuery: query, page: page)))
            let errorEvents = searchEvents.errors().map { $0.localizedDescription }.map(Mutation.errorOccurred)
            let searchMutations = Observable.merge(successEvents, errorEvents)
            return .concat(
                .just(Mutation.toggleLoading(true)),
                searchMutations,
                .just(Mutation.toggleLoading(false))
            )

        case .search(let query):
            let page = initialState.page
            let searchEvents = searchService.search(query: query, page: .first).asObservable().materialize().share()
            let searchMutations = Observable.merge(
                .concat( searchEvents.elements().map(Mutation.itemsLoaded), .just(.pageUpdated(searchQuery: query, page: page))),
                searchEvents.errors().map { $0.localizedDescription }.map(Mutation.errorOccurred)
            )
            return .concat(
                .just(.itemsLoaded([])),
                .just(.toggleLoading(true)),
                searchMutations,
                .just(.toggleLoading(false))
            )
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {

        case .errorOccurred(let errorMessage):
            print(errorMessage)

        case .itemsLoaded(let items):
            newState.items = items

        case .itemsAppended(let items):
            newState.items += items

        case .toggleLoading(let isLoading):
            newState.isLoading = isLoading

        case .pageUpdated(searchQuery: let searchQuery, page: let page):
            newState.searchQuery = searchQuery
            newState.page = page
        }
        return newState
    }

    func transform(action: Observable<Action>) -> Observable<Action> {
        let searchActions = action.partition {
            if case .search = $0 {
                return true
            }
            return false
        }
        let filteredSearchActions = searchActions.matches
            .skip(1)
            .filter {
                guard case let .search(query) = $0 else {
                    return false
                }
                return !query.isEmpty
            }
            .distinctUntilChanged()
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
        return Observable.merge(searchActions.nonMatches, filteredSearchActions).debug("PENIS")
    }
}

// MARK: - State
extension GameSearchViewModel2.State {
    var dataSource: [GameSearchViewModel2.SectionType] {
        return [GameSearchViewModel2.SectionType(model: "", items: items)]
    }
}
