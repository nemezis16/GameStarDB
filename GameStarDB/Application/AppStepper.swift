//
//  AppStepper.swift
//  GameStarDB
//
//  Created by Roman on 03.05.2020.
//  Copyright © 2020 Roman Osadchuk. All rights reserved.
//

import RxFlow
import RxCocoa

class AppStepper: Stepper {
    let steps = PublishRelay<Step>()

    var initialStep: Step {
        return AppStep.onboardingIsComplete
    }

    //In this class you can declare global variables and inject services. Todo later
}
