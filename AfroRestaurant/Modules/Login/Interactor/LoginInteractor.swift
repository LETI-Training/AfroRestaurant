class LoginInteractor {
    let authService: AuthorizationServiceInput?
    var authErrorListner: ((_ errorText: String) -> Void)?
    
    init(authService: AuthorizationServiceInput?) {
        self.authService = authService
        authService?.addListner(self)
    }
    
    deinit {
        authService?.removeListner(self)
    }
}

extension LoginInteractor: LoginInteractorInput {
    func signIn(email: String, password: String) {
        authService?.signIn(email: email, password: password)
    }
    
    func resetPassword(email: String) {
        authService?.resetPassword(email: email)
    }
}

extension LoginInteractor: AuthorizationServiceOutput {
    func authServiceDidLogUserOut() {}
    
    func authServiceDidSignUserIn() {}
    
    func authServiceDidRegisterUser() {}
    
    func authServiceDidSendOutPasswordResetMail() {}
    
    func authorizationService(didFailWith error: AuthorizationService.ErrorType) {
        switch error {
            
        case .login(error: let error), .passwordReset(error: let error):
            authErrorListner?(error.localizedDescription)
        case .register, .logout:
        break
        }
    }
    
    
}
