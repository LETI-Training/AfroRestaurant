class AdminHomeInteractor {
    
    private let authService: AuthorizationServiceInput?
    var authErrorListner: ((_ errorText: String) -> Void)?
    
    init(authService: AuthorizationServiceInput?) {
        self.authService = authService
        authService?.addListner(self)
    }
    
    deinit {
        authService?.removeListner(self)
    }
}

extension AdminHomeInteractor: AdminHomeInteractorInput {
    func performLogout() {
        authService?.signOut()
    }
}

extension AdminHomeInteractor: AuthorizationServiceOutput {
    func authorizationService(didFailWith error: AuthorizationService.ErrorType) {
        switch error {
            
        case .logout(error: let error):
            authErrorListner?(error.localizedDescription)
        case .register, .login, .passwordReset:
            break
        }
    }
}
