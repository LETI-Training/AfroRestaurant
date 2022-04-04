class AdminProfitsPresenter {
    weak var view: AdminProfitsViewInput?
    var interactor: AdminProfitsInteractorInput?
    var router: AdminProfitsRouter?

    init() {}
}

extension AdminProfitsPresenter: AdminProfitsPresenterProtocol {

    func viewDidLoad() {
    }
}
