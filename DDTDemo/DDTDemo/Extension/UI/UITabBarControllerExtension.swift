//
//  UITabBarControllerExtension.swift
//  DDTDemo
//
//  Created by Allen Lai on 2019/7/30.
//  Copyright © 2019 Allen Lai. All rights reserved.
//

import UIKit

struct ViewControllerInfo {
    var hasNavigation: Bool
    var viewController: UIViewController
    var tabBarItem: UITabBarItem?
}

extension UITabBarController {
    func setupViewControllers(_ viewControllerInfos: [ViewControllerInfo]) {
        var viewControllers = [UIViewController]()
        viewControllerInfos.forEach {
            let viewController = $0.viewController
            if $0.hasNavigation {
                let navigationController = UINavigationController(rootViewController: viewController)
                navigationController.tabBarItem = $0.tabBarItem
                viewControllers.append(navigationController)
            } else {
                viewController.tabBarItem = $0.tabBarItem
                viewControllers.append(viewController)
            }
        }
        setViewControllers(viewControllers, animated: true)
    }
}
