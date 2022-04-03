//
//  AdminAppCoordinatorFactory.swift
//  AfroRestaurant
//
//  Created by Ebubechukwu Dimobi on 03.04.2022.
//  Copyright © 2022 AfroRestaurant. All rights reserved.
//

import UIKit

class AdminAppCoordinatorFactory {
    private func createHomeVC() -> UINavigationController {
//        let discoverViewController = DiscoverAssembly.assemble(endpoint: .getTopHeadlines)
//        discoverViewController.title = "Discover"
//        discoverViewController.tabBarItem = UITabBarItem(title: "Discover", image: UIImage.tabBarItems.discover, selectedImage:  UIImage.tabBarItems.discover)
        return UINavigationController(rootViewController: UIViewController())
    }
    
    private func createProfitsVC() -> UINavigationController {
        UINavigationController(rootViewController: UIViewController())
    }
    
    private func createInventoryVC() -> UINavigationController {
        UINavigationController(rootViewController: UIViewController())
    }
}

extension AdminAppCoordinatorFactory: AppCordinatorFactory {
    func createTabBar() -> UITabBarController {
        let tabBar = UITabBarController()
        tabBar.viewControllers = [createHomeVC(), createProfitsVC(), createInventoryVC()]
        return tabBar
    }
}
