//
//  AuthorizationService.swift
//  AfroRestaurant
//
//  Created by Ebubechukwu Dimobi on 03.04.2022.
//  Copyright © 2022 AfroRestaurant. All rights reserved.
//

import Firebase

//MARK: - Protocols

protocol AuthorizationServiceInput: AnyObject {
    func signIn(email: String, password: String)
    func signUp(
        email: String,
        password: String,
        fullName: String,
        phoneNumber: String
    )
    func signOut()
    func resetPassword(email: String)
    func isUserAuthorized() -> Bool
    func getUserInfo() -> (name: String?, email: String?)
    
    func addListner(_ listner: AuthorizationServiceOutput)
    func removeListner(_ listner: AuthorizationServiceOutput)
}

protocol AuthorizationServiceOutput: AnyObject {
    func authServiceDidLogUserOut()
    func authServiceDidSignUserIn()
    func authServiceDidRegisterUser()
    func authServiceDidSendOutPasswordResetMail()
    func authorizationService(didFailWith error: AuthorizationService.ErrorType)
}

class AuthorizationService {
    
    enum ErrorType: Error {
        case login(error: Error)
        case register(error: Error)
        case passwordReset(error: Error)
        case logout(error: Error)
    }
    
    private enum UpdateType {
        case error(ErrorType)
        case successLogout
        case successLogin
        case successRegister
        case successPasswordReset
    }
    
    var outputs: [AuthorizationServiceOutput] = []
    weak var appInteractor: AppInteractorProtocol?
    
    let updateLock = NSRecursiveLock()
    
    private func sendUpdateNotification(updateType: UpdateType) {
        updateLock.lock()
        self.outputs.forEach {
            switch updateType {
            case .error(let errorType):
                $0.authorizationService(didFailWith: errorType)
            case .successLogout:
                $0.authServiceDidLogUserOut()
            case .successLogin:
                $0.authServiceDidSignUserIn()
            case .successRegister:
                $0.authServiceDidRegisterUser()
            case .successPasswordReset:
                $0.authServiceDidSendOutPasswordResetMail()
            }
        }
        updateLock.unlock()
    }
}

extension AuthorizationService: AuthorizationServiceInput {
    func isUserAuthorized() -> Bool {
        Firebase.Auth.auth().currentUser != nil
    }
    
    func addListner(_ listner: AuthorizationServiceOutput) {
        updateLock.lock()
        outputs.append(listner)
        updateLock.unlock()
    }
    
    func removeListner(_ listner: AuthorizationServiceOutput) {
        updateLock.lock()
        outputs.removeAll(where: { $0 === listner})
        updateLock.unlock()
    }
    
    func signIn(email: String, password: String) {
        Firebase.Auth.auth().signIn(withEmail: email, password: password) { [weak self] (result, error) in
            guard let self = self else { return }
            
            if let error = error {
                self.sendUpdateNotification(updateType: .error(.login(error: error)))
                return
            }
            guard result != nil else {
                self.sendUpdateNotification(updateType: .error(.login(error: NSError(domain: "Couldn't Complete Login", code: 1))))
                return
            }
            self.sendUpdateNotification(updateType: .successLogin)
            self.appInteractor?.userAuthorizationStateChanged()
        }
    }
    
    
    func signUp(email: String, password: String, fullName: String, phoneNumber: String) {
        Firebase.Auth.auth().createUser(withEmail: email, password: password) { [weak self] (result, error) in
            guard let self = self else { return }
            
            if let error = error {
                self.sendUpdateNotification(updateType: .error(.register(error: error)))
                return
            }
            
            guard result != nil else {
                self.sendUpdateNotification(updateType: .error(.register(error: NSError(domain: "Couldn't Complete Registration", code: 1))))
                return
            }
            
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            changeRequest?.displayName = fullName
            
            changeRequest?.commitChanges {  (error) in }
            
            self.sendUpdateNotification(updateType: .successLogin)
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            appInteractor?.userAuthorizationStateChanged()
        } catch {
            sendUpdateNotification(updateType: .error(.logout(error: error)))
        }
    }
    
    
    func resetPassword(email: String) {
        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
            guard let self = self else {
                return
            }
            if let error = error {
                self.sendUpdateNotification(updateType: .error(.passwordReset(error: error)))
                return
            }
        }
    }
    
    func getUserInfo() -> (name: String?, email: String?) {
        (Firebase.Auth.auth().currentUser?.displayName, Firebase.Auth.auth().currentUser?.email)
    }
    
}


extension AuthorizationServiceOutput {
    func authServiceDidLogUserOut() {}
    
    func authServiceDidSignUserIn() {}
    
    func authServiceDidRegisterUser() {}
    
    func authServiceDidSendOutPasswordResetMail() {}
    
    func authorizationService(didFailWith error: AuthorizationService.ErrorType) {}
}
