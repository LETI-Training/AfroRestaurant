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
        let viewController = ConsumerHomeAssembly.assemble()
        viewController.tabBarItem = UITabBarItem(
            title: "Home",
            image: .tabBarItems.home,
            selectedImage: .tabBarItems.homeHighlighted
        )
        return CustomNavigationController(rootViewController: viewController)
    }
    
    private func createFavoritesVC() -> UINavigationController {
        let viewController = ConsumerFavoritesAssembly.assemble()
        viewController.tabBarItem = UITabBarItem(
            title: "Favorites",
            image: .tabBarItems.favorite,
            selectedImage: .tabBarItems.favoriteHighlighted
        )
        return CustomNavigationController(rootViewController: viewController)
    }
    
    private func createCartVC() -> UINavigationController {
        let viewController = ConsumerCartAssembly.assemble()
        viewController.tabBarItem = UITabBarItem(
            title: "Cart",
            image: .tabBarItems.cart,
            selectedImage: .tabBarItems.cartHighlighted
        )
        return CustomNavigationController(rootViewController: viewController)
    }
    
    private func createProfileVC() -> UINavigationController {
        let viewController = ConsumerProfileAssembly.assemble()
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
        appearance.backgroundColor = .tabBarPrimary
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.textPrimary]
        tabBarVC.tabBar.standardAppearance = appearance
        tabBarVC.viewControllers = [createHomeVC(), createFavoritesVC(), createCartVC(), createProfileVC()]
        return tabBarVC
    }
}

