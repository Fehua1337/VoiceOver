//
//  AppDelegate.swift
//  Counter VoiceOverTest
//
//  Created by Alisher Tulembekov on 19.11.2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        window?.rootViewController = UINavigationController(rootViewController: CounterViewController())
        window?.makeKeyAndVisible()
        return true
    }


}

