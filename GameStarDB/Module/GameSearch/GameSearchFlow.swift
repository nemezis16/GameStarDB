//
//  GameSearchFlow.swift
//  GameStarDB
//
//  Created by Roman on 26.05.2020.
//  Copyright © 2020 Roman Osadchuk. All rights reserved.
//

import RxFlow

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
        case .movieIsPicked(id: let id):
            return .none
        default:
            return .none
        }
    }
}

// MARK: - Private methods
extension GameSearchFlow {
    private func navigateToGameSearchScreen() -> FlowContributors {
        let searchViewController = GameSearchViewController.instantiate()
        searchViewController.reactor = Dependencies.gameSearchReactor

        rootViewController.pushViewController(searchViewController, animated: false)

        return .none
    }
}
