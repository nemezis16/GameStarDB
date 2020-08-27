//
//  AppFlow.swift
//  GameStarDB
//
//  Created by Roman on 03.05.2020.
//  Copyright © 2020 Roman Osadchuk. All rights reserved.
//

import RxFlow

class AppFlow: Flow {
    private lazy var rootViewContoller: UINavigationController = {
        let viewController = UINavigationController()

        return viewController
    }()

    var root: Presentable {
        return rootViewContoller
    }

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else { return .none }

        switch step {
        case .onboardingIsComplete:
            return navigationToGameListScreen()
        default:
            return .none
        }
    }
}


// MARK: - Private functions
extension AppFlow {
    private func navigationToGameListScreen() -> FlowContributors {
        let gameSearchFlow = GameSearchFlow(rootViewController: rootViewContoller)
        return .one(flowContributor: .contribute(withNextPresentable: gameSearchFlow,
                                                 withNextStepper: OneStepper(withSingleStep: AppStep.gameListIsRequired)))
    }
}
