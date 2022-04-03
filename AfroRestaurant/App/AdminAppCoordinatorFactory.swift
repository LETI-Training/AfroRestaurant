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
        let viewController = AdminHomeAssembly.assemble()
        viewController.title = "Testing"
        viewController.tabBarItem = UITabBarItem(
            title: "Home",
            image: .tabBarItems.home,
            selectedImage: .tabBarItems.homeHighlighted
        )
        return UINavigationController(rootViewController: viewController)
    }
    
    private func createProfitsVC() -> UINavigationController {
        let viewController = AdminHomeAssembly.assemble()
        viewController.title = "Testing"
        viewController.tabBarItem = UITabBarItem(
            title: "Profits",
            image: .tabBarItems.profits,
            selectedImage: .tabBarItems.profitsHighlighted
        )
        return UINavigationController(rootViewController: viewController)
    }
    
    private func createInventoryVC() -> UINavigationController {
        let viewController = AdminHomeAssembly.assemble()
        viewController.title = "Testing"
        viewController.tabBarItem = UITabBarItem(
            title: "Inventory",
            image: .tabBarItems.inventory,
            selectedImage: .tabBarItems.inventoryHighlighted
        )
        return UINavigationController(rootViewController: viewController)
    }
}

extension AdminAppCoordinatorFactory: AppCordinatorFactory {
    func createTabBar() -> UITabBarController {
        let tabBarVC = UITabBarController()
        let appearance = UITabBarAppearance()
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.textPrimary]
        tabBarVC.tabBar.standardAppearance = appearance
        tabBarVC.viewControllers = [createHomeVC(), createProfitsVC(), createInventoryVC()]
        tabBarVC.tabBar.backgroundColor = .tabBarPrimary
        return tabBarVC
    }
}
