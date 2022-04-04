//
//  AppCoordinator.swift
//  AfroRestaurant
//
//  Created by Ebubechukwu Dimobi on 03.04.2022.
//  Copyright © 2022 AfroRestaurant. All rights reserved.
//

import UIKit

protocol AppCoordinatorProtocol: AnyObject {
    func createLandingPage(scene: UIWindowScene)
    func createHomePages(for userType: UserType, scene: UIWindowScene)
}

protocol AppCordinatorFactory: AnyObject {
    func createTabBar() -> UITabBarController
}

class AppCoordinator {
    var window: UIWindow?
    var adminFactory: AppCordinatorFactory
    var customerFactory: AppCordinatorFactory
    
    init(
        adminFactory: AppCordinatorFactory,
        customerFactory: AppCordinatorFactory
    ) {
        self.adminFactory = adminFactory
        self.customerFactory = customerFactory
    }
}

// MARK: Landing page case
extension AppCoordinator {
    
    private func createLoginVC() -> UINavigationController {
        let loginViewController = LoginAssembly.assemble()
        return UINavigationController(rootViewController: loginViewController)
    }
}

extension AppCoordinator: AppCoordinatorProtocol {
    
    func createLandingPage(scene: UIWindowScene) {
        window = UIWindow(windowScene: scene)
        window?.rootViewController = createLoginVC()
        window?.makeKeyAndVisible()
    }
    
    func createHomePages(for userType: UserType, scene: UIWindowScene) {
        window = UIWindow(windowScene: scene)
        UITabBar.appearance().tintColor = .brandGreen
        UIBarButtonItem.appearance()
            .setTitleTextAttributes(
                [NSAttributedString.Key.font: UIFont.font(.medium, size: 10.0)], for: .normal
            )
        UIBarButtonItem.appearance()
            .setTitleTextAttributes(
                [NSAttributedString.Key.font: UIFont.font(.medium, size: 10.0)],
                for: .highlighted
            )
        switch userType {
        case .customer:
            window?.rootViewController = customerFactory.createTabBar()
        case .admin:
            window?.rootViewController = adminFactory.createTabBar()
        }
        
        window?.makeKeyAndVisible()
    }
}
