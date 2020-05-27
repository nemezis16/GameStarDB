//
//  AppDelegate.swift
//  GameStarDB
//
//  Created by Roman Osadchuk on 05.01.2020.
//  Copyright © 2020 Roman Osadchuk. All rights reserved.
//

import UIKit
import RxFlow
import RxSwift
import RxCocoa

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let disposeBag = DisposeBag()
    var window: UIWindow?
    var coordinator = FlowCoordinator()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)

        coordinator.rx.willNavigate.subscribe(onNext: { (flow, step) in
            print("will navigate to flow=\(flow) and step=\(step)")
        }).disposed(by: self.disposeBag)

        coordinator.rx.didNavigate.subscribe(onNext: { (flow, step) in
            print("did navigate to flow=\(flow) and step=\(step)")
        }).disposed(by: self.disposeBag)

        let appFlow = AppFlow()

        Flows.whenReady(flow1: appFlow) { [unowned self] root in
            self.window?.rootViewController = root
            self.window?.makeKeyAndVisible()
        }

        coordinator.coordinate(flow: appFlow, with: AppStepper())

        return true
    }
}

