//
//  GameSearchViewModel.swift
//  GameStarDB
//
//  Created by Roman Osadchuk on 06.01.2020.
//  Copyright © 2020 Roman Osadchuk. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

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
        self.loading.onNext(true)
        
        NetworkService.shared.request(target: .search(name: data)) { result in
            self.loading.onNext(false)
            switch result {
            case .success(let returnJson) :
                let gameList = returnJson.arrayValue.compactMap { return GameListItem(data: try! $0.rawData())}
                self.gameList.onNext(gameList)
            case .failure(let failure) :
                switch failure {
                case .connectionError:
                    self.error.onNext(.internetError("Check your Internet connection."))
                case .authorizationError(let errorJson):
                    self.error.onNext(.serverMessage(errorJson["message"].stringValue))
                default:
                    self.error.onNext(.serverMessage("Unknown Error"))
                }
            }
        }
    }
}
