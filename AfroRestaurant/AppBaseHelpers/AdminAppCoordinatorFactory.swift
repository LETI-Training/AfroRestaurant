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
        viewController.tabBarItem = UITabBarItem(
            title: "Home",
            image: .tabBarItems.home,
            selectedImage: .tabBarItems.homeHighlighted
        )
        return CustomNavigationController(rootViewController: viewController)
    }
    
    private func createProfitsVC() -> UINavigationController {
        let viewController = AdminProfitsAssembly.assemble()
        viewController.tabBarItem = UITabBarItem(
            title: "Profits",
            image: .tabBarItems.profits,
            selectedImage: .tabBarItems.profitsHighlighted
        )
        return CustomNavigationController(rootViewController: viewController)
    }
    
    private func createInventoryVC() -> UINavigationController {
        let viewController = AdminInventoryAssembly.assemble()
        viewController.tabBarItem = UITabBarItem(
            title: "Inventory",
            image: .tabBarItems.inventory,
            selectedImage: .tabBarItems.inventoryHighlighted
        )
        return CustomNavigationController(rootViewController: viewController)
    }
}

extension AdminAppCoordinatorFactory: AppCordinatorFactory {
    func createTabBar() -> UITabBarController {
        let tabBarVC = CustomTabBarController()
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = .tabBarPrimary
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.textPrimary]
        tabBarVC.tabBar.standardAppearance = appearance
        tabBarVC.viewControllers = [createHomeVC(), createProfitsVC(), createInventoryVC()]
        return tabBarVC
    }
}
