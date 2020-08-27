//
//  AppStep.swift
//  GameStarDB
//
//  Created by Roman on 03.05.2020.
//  Copyright © 2020 Roman Osadchuk. All rights reserved.
//

import RxFlow

enum AppStep: Step {
    case onboardingIsComplete
    case gameListIsRequired
    case movieIsPicked(item: GameListItem)
}
