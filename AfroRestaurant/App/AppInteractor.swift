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
    func checkIfUserisAuthenticated()
}

class AppInteractor: AppInteractorProtocol {
    
    private var coordinator: AppCoordinatorProtocol
    private weak var windowScene: UIWindowScene!
//    private var profileService: ProfileServiceProtocol?
    
    
    init(
        windowScene: UIWindowScene,
        coordinator: AppCoordinatorProtocol
    ) {
        self.windowScene = windowScene
        self.coordinator = coordinator
        self.checkIfUserisAuthenticated()
        
        setupFirebase()
        setupServiceLocator()
    }
    
    private func setupFirebase() {
        FirebaseApp.configure()
    }
    
    private func setupServiceLocator() {
        
//        let networkService = NetworkService<ArticleEndpoint>()
//        ServiceLocator.shared.addService(service: networkService as NetworkService)
//
//        let profileService = ProfileService()
//        self.profileService = profileService
//        profileService.appInteratcor = self
//        ServiceLocator.shared.addService(service: profileService as ProfileService)
//
//        let imagePickerManager = ImagePickerManager()
//        ServiceLocator.shared.addService(service: imagePickerManager as ImagePickerManager )
        
    }
    
     func checkIfUserisAuthenticated() {
         coordinator.createLandingPage(scene: windowScene)
//        guard let profileService = profileService else { return }
//        if profileService.checkIfUserIsAuth() {
//            coordinator?.createHomePages(scene: windowScene)
//        } else {
//            coordinator?.createLandingPage(scene: windowScene)
//        }
    }
}



