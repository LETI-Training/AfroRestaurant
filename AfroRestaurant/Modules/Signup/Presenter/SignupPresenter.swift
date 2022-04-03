class SignupPresenter {
    weak var view: SignupViewInput?
    var interactor: SignupInteractorInput?
    var router: SignupRouter?

    init() {}
}

extension SignupPresenter: SignupPresenterProtocol {

    func viewDidLoad() {
    }
}
