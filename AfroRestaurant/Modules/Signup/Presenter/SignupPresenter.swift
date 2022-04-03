class SignupPresenter {
    weak var view: SignupViewInput?
    var interactor: SignupInteractorInput?
    var router: SignupRouter?
    
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

extension SignupPresenter: SignupPresenterProtocol {
    func didTapCreateAccountButton(
        name: String?,
        email: String?,
        password: String?,
        passwordVerify: String?,
        phoneNumber: String?
    ) {
        guard
            let name = name,
            let email = email,
            let password = password,
            let passwordVerify = passwordVerify,
            let phoneNumber = phoneNumber,
            !name.isEmpty,
            !email.isEmpty,
            !password.isEmpty,
            !passwordVerify.isEmpty,
            !phoneNumber.isEmpty else {
                view?.presentAlert(
                    title: "Error",
                    message: "Please Fill All Fields",
                    action: .init(actionText: "Ok", actionHandler: {})
                )
                return
            }
        
        guard password == passwordVerify else {
            view?.presentAlert(
                title: "Error",
                message: "Passwords are not the same. Please Try again",
                action: .init(actionText: "Ok", actionHandler: {})
            )
            return
        }
        
        interactor?.signUp(
            fullName: name,
            email: email,
            password: password,
            phoneNumber: phoneNumber
        )
        
    }
    
    func didTapLogInLabel() {
        router?.routeBack()
    }
    
    func viewDidLoad() {
        setupErrorListner()
    }
}
