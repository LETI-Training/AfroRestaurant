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
            coordinator.createHomePages(for: .admin, scene: windowScene)
        } else {
            coordinator.createLandingPage(scene: windowScene)
        }
    }
    
    private func setupServiceLocator() {
        guard let authService = authService else {
            return
        }
        DispatchQueue.global().async {
            let dataBaseService = DataBaseService()
            
            ServiceLocator.shared.addService(service: authService as AuthorizationServiceInput)
            ServiceLocator.shared.addService(service: dataBaseService as DataBaseServiceProtocol)
        }
    }
}

extension AppInteractor: AppInteractorProtocol {
    func userAuthorizationStateChanged() {
        startProcess()
    }
}
