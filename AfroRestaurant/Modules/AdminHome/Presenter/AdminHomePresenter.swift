class AdminHomePresenter {
    weak var view: AdminHomeViewInput?
    var interactor: AdminHomeInteractorInput?
    var router: AdminHomeRouter?

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

extension AdminHomePresenter: AdminHomePresenterProtocol {
    func didTapProfileImage() {
        interactor?.performLogout()
    }
    
    func viewDidLoad() {
        setupErrorListner()
    }
}
