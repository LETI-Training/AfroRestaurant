class SignupInteractor {
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

extension SignupInteractor: SignupInteractorInput {
    func signUp(
        fullName: String,
        email: String,
        password: String,
        phoneNumber: String
    ) {
        authService?.signUp(
            email: email,
            password: password,
            fullName: fullName,
            phoneNumber: phoneNumber
        )
    }
}

extension SignupInteractor: AuthorizationServiceOutput {
    func authorizationService(didFailWith error: AuthorizationService.ErrorType) {
        switch error {
            
        case .register(error: let error):
            authErrorListner?(error.localizedDescription)
        case .login, .logout, .passwordReset:
            break
        }
    }
}
