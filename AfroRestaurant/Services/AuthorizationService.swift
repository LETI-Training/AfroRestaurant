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
    var userType: UserType { get }
    
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
    
    func addListner(_ listener: AuthorizationServiceOutput)
    func removeListner(_ listener: AuthorizationServiceOutput)
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
    
    private var outputs: [WeakRefeferenceWrapper<AuthorizationServiceOutput>] = []
    weak var appInteractor: AppInteractorProtocol?
    private let updateLock = NSRecursiveLock()
    
    private var email: String {
        Firebase.Auth.auth().currentUser?.email ?? ""
    }
    
    private func sendUpdateNotification(updateType: UpdateType) {
        updateLock.lock()
        defer { updateLock.unlock() }
        
        self.outputs.forEach {
            switch updateType {
            case .error(let errorType):
                $0.object?.authorizationService(didFailWith: errorType)
            case .successLogout:
                $0.object?.authServiceDidLogUserOut()
            case .successLogin:
                $0.object?.authServiceDidSignUserIn()
            case .successRegister:
                $0.object?.authServiceDidRegisterUser()
            case .successPasswordReset:
                $0.object?.authServiceDidSendOutPasswordResetMail()
            }
        }
    }
}

extension AuthorizationService: AuthorizationServiceInput {
    var userType: UserType {
        email.components(separatedBy: "@").last == "afro.com"
        ? .admin
        : .customer
    }
    
    func isUserAuthorized() -> Bool {
        Firebase.Auth.auth().currentUser != nil
    }
    
    func addListner(_ listener: AuthorizationServiceOutput) {
        updateLock.lock()
        defer { updateLock.unlock() }
        
        outputs.append(WeakRefeferenceWrapper(object: listener) )
        outputs.removeAll(where: { $0.object == nil })
    }
    
    func removeListner(_ listener: AuthorizationServiceOutput) {
        updateLock.lock()
        defer { updateLock.unlock() }
        
        outputs.removeAll(where: { $0.object === listener || $0.object == nil })
    }
    
    func signIn(email: String, password: String) {
        Firebase.Auth.auth().signIn(withEmail: email, password: password) { [weak self] (result, error) in
            guard let self = self else { return }
            
            if let error = error {
                self.sendUpdateNotification(updateType: .error(.login(error: error)))
                return
            }
            guard result != nil else {
                self.sendUpdateNotification(
                    updateType: .error(.login(error: NSError(domain: "Couldn't Complete Login", code: 1)))
                )
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
                self.sendUpdateNotification(
                    updateType: .error(.register(error: NSError(domain: "Couldn't Complete Registration", code: 1)))
                )
                return
            }
            
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            changeRequest?.displayName = fullName
            
            changeRequest?.commitChanges {  (error) in }
            
            self.sendUpdateNotification(updateType: .successRegister)
            self.appInteractor?.userAuthorizationStateChanged()
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
            guard let self = self else { return }
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
