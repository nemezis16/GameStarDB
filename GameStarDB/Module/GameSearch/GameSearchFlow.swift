//
//  GameSearchFlow.swift
//  GameStarDB
//
//  Created by Roman on 26.05.2020.
//  Copyright © 2020 Roman Osadchuk. All rights reserved.
//

import RxFlow
import SwiftUI

class GameSearchFlow: Flow {
    var root: Presentable { return rootViewController }

    private let rootViewController: UINavigationController
    
    init(rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
    }

    func navigate(to step: Step) -> FlowContributors {
        guard let appStep = step as? AppStep else { return .none }

        switch appStep {
        case .gameListIsRequired:
            return navigateToGameSearchScreen()

        case .movieIsPicked(item: let item):
            return navigateToGameDetailScreen(item: item)

        default:
            return .none
        }
    }
}

// MARK: - Private methods
extension GameSearchFlow {
    private func navigateToGameSearchScreen() -> FlowContributors {
        let searchViewController = GameSearchViewController.instantiate()
        let reactor = Dependencies.gameSearchReactor
        searchViewController.reactor = reactor

        rootViewController.pushViewController(searchViewController, animated: true)

        return .one(flowContributor: .contribute(withNextPresentable: searchViewController,
                                                 withNextStepper: reactor,
                                                 allowStepWhenNotPresented: true))
    }

    private func navigateToGameDetailScreen(item: GameListItem) -> FlowContributors {
        let reactor = GameDetailReactor(item: item)

        let gameDetailViewController = GameDetailViewController.instantiate()
        gameDetailViewController.reactor = reactor

        rootViewController.pushViewController(gameDetailViewController, animated: true)

        return .none
    }
}
