//
//  AppInteractor.swift
//  AfroRestaurant
//
//  Created by Ebubechukwu Dimobi on 03.04.2022.
//  Copyright © 2022 AfroRestaurant. All rights reserved.
//

import UIKit
import Firebase

protocol AppInteractorProtocol: AnyObject {
    func userAuthorizationStateChanged()
}

class AppInteractor {
    
    private var coordinator: AppCoordinatorProtocol
    private weak var windowScene: UIWindowScene!
    private let authService: AuthorizationServiceInput?
    
    init(
        windowScene: UIWindowScene,
        coordinator: AppCoordinatorProtocol,
        authService: AuthorizationServiceInput
    ) {
        self.windowScene = windowScene
        self.coordinator = coordinator
        self.authService = authService
        setupFirebase()
        setupServiceLocator()
        startProcess()
    }
    
    private func setupFirebase() {
        FirebaseApp.configure()
    }
    
    private func startProcess() {
        guard let authService = authService else {
            return
        }
        
        if authService.isUserAuthorized() {
            coordinator.createHomePages(for: authService.userType, scene: windowScene)
        } else {
            coordinator.createLandingPage(scene: windowScene)
        }
    }
    
    private func setupServiceLocator() {
        guard let authService = authService else { return }
            let adminDataBaseService = AdminDataBaseService()
            let consumerDataBase = ConsumerDataBaseService(adminDataBaseService: adminDataBaseService)
            
            ServiceLocator.shared.addService(service: authService as AuthorizationServiceInput)
            ServiceLocator.shared.addService(service: adminDataBaseService as AdminDataBaseServiceProtocol)
            ServiceLocator.shared.addService(service: consumerDataBase as ConsumerDataBaseServiceProtocol)
    }
}

extension AppInteractor: AppInteractorProtocol {
    func userAuthorizationStateChanged() {
        startProcess()
    }
}
