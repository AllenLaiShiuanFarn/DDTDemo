//
//  AppDelegate.swift
//  DDTDemo
//
//  Created by Allen Lai on 2019/7/28.
//  Copyright © 2019 Allen Lai. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    // MARK: - Properties
    var window: UIWindow?
    
    // MARK: - App lifecycle
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        guard let window = window else { fatalError() }
        window.makeKeyAndVisible()
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [PlantListViewController()]
        window.rootViewController = tabBarController
        
        return true
    }
}
