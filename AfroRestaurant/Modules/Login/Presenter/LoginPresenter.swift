class LoginPresenter {
    weak var view: LoginViewInput?
    var interactor: LoginInteractorInput?
    var router: LoginRouter?

    init() {}
}

extension LoginPresenter: LoginPresenterProtocol {
    func viewDidLoad() {}
    
    func didTapOnSignInButton(email: String?, password: String?) {
        
    }
    
    func didTapOnForgetPassword() {
        
    }
    
    func didTapOnCreateNewAccount() {
        router?.routeToSignupPage()
    }
}
