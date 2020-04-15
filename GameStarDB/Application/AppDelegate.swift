//
//  AppDelegate.swift
//  GameStarDB
//
//  Created by Roman Osadchuk on 05.01.2020.
//  Copyright © 2020 Roman Osadchuk. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let searchViewController = GameSearchViewController.instantiate()
        searchViewController.reactor = Dependencies.searchViewModel2

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: searchViewController)
        window?.makeKeyAndVisible()

        return true
    }
}

