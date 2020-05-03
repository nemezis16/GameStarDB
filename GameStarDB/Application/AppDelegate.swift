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

        self.coordinator.rx.willNavigate.subscribe(onNext: { flow, step in
            print("will navigate to flow=\(flow) and step=\(step)")
        }).disposed(by: disposeBag)



        let searchViewController = GameSearchViewController.instantiate()
        searchViewController.reactor = Dependencies.gameSearchReactor

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: searchViewController)
        window?.makeKeyAndVisible()

        return true
    }
}

