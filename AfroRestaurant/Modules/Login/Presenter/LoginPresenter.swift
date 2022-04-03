class LoginPresenter {
    private let disposeBag = DisposeBag()
    weak var view: LoginViewInput?
    var interactor: LoginInteractorInput?
    var router: LoginRouter?
    var textManager: LoginTextManagerProtocol?

    init() {
        BaseTextManager.onLanguageChanged.bind {[weak self] in
            self?.languageChanged()
        }.disposed(by: self.disposeBag)
    }
}

extension LoginPresenter: LoginPresenterProtocol {

    func viewDidLoad() {
    }

    private func languageChanged() {
        self.view.updateTexts()
    }
}
