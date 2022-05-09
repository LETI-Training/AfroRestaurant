//
//  ConsumerAppCoordinatorFactory.swift
//  AfroRestaurant
//
//  Created by Ebubechukwu Dimobi on 09.05.2022.
//  Copyright © 2022 AfroRestaurant. All rights reserved.
//

import UIKit

class ConsumerAppCoordinatorFactory {
    private func createHomeVC() -> UINavigationController {
        let viewController = AdminHomeAssembly.assemble()
        viewController.tabBarItem = UITabBarItem(
            title: "Home",
            image: .tabBarItems.home,
            selectedImage: .tabBarItems.homeHighlighted
        )
        return CustomNavigationController(rootViewController: viewController)
    }
    
    private func createFavoritesVC() -> UINavigationController {
        let viewController = AdminProfitsAssembly.assemble()
        viewController.tabBarItem = UITabBarItem(
            title: "Favorites",
            image: .tabBarItems.favorite,
            selectedImage: .tabBarItems.favoriteHighlighted
        )
        return CustomNavigationController(rootViewController: viewController)
    }
    
    private func createCartVC() -> UINavigationController {
        let viewController = AdminInventoryAssembly.assemble()
        viewController.tabBarItem = UITabBarItem(
            title: "Cart",
            image: .tabBarItems.cart,
            selectedImage: .tabBarItems.cartHighlighted
        )
        return CustomNavigationController(rootViewController: viewController)
    }
    
    private func createProfileVC() -> UINavigationController {
        let viewController = AdminInventoryAssembly.assemble()
        viewController.tabBarItem = UITabBarItem(
            title: "Profile",
            image: .tabBarItems.profile,
            selectedImage: .tabBarItems.profileHighlighted
        )
        return CustomNavigationController(rootViewController: viewController)
    }
}

extension ConsumerAppCoordinatorFactory: AppCordinatorFactory {
    func createTabBar() -> UITabBarController {
        let tabBarVC = CustomTabBarController()
        let appearance = UITabBarAppearance()
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.textPrimary]
        tabBarVC.tabBar.standardAppearance = appearance
        tabBarVC.viewControllers = [createHomeVC(), createFavoritesVC(), createCartVC(), createProfileVC()]
        tabBarVC.tabBar.backgroundColor = .tabBarPrimary
        return tabBarVC
    }
}

