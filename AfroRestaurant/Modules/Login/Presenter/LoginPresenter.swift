class LoginPresenter {
    weak var view: LoginViewInput?
    var interactor: LoginInteractorInput?
    var router: LoginRouter?

    init() {
    }
}

extension LoginPresenter: LoginPresenterProtocol {

    func viewDidLoad() {
    }
}
