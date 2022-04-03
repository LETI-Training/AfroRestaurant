class LoginPresenter {
    weak var view: LoginViewInput?
    var interactor: LoginInteractorInput?
    var router: LoginRouter?
    
    init() {}
    
    private func setupErrorListner() {
        interactor?.authErrorListner = { [weak self] errorText in
            self?.view?.presentAlert(
                title: "Error",
                message: errorText,
                action: .init(actionText: "Ok", actionHandler: {})
            )
        }
    }
}

extension LoginPresenter: LoginPresenterProtocol {
    func didTapOnForgetPassword(email: String) {
        interactor?.resetPassword(email: email)
    }
    
    func viewDidLoad() {
        setupErrorListner()
    }
    
    func didTapOnSignInButton(email: String?, password: String?) {
        if email == nil || email?.isEmpty == true {
            view?.presentAlert(
                title: "Error",
                message: "Please enter email",
                action: .init(actionText: "Ok", actionHandler: {})
            )
            return
        }
        
        if password == nil || password?.isEmpty == true {
            view?.presentAlert(
                title: "Error",
                message: "Please enter password",
                action: .init(actionText: "Ok", actionHandler: {})
            )
        }
        
        guard
            let email = email,
            let password = password else { return }
        interactor?.signIn(email: email, password: password)
    }
    
    func didTapOnCreateNewAccount() {
        router?.routeToSignupPage()
    }
}
