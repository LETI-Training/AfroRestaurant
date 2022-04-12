class AdminNewDishPresenter {
    weak var view: AdminNewDishViewInput?
    var interactor: AdminNewDishInteractorInput?
    var router: AdminNewDishRouter?

    init() {}
}

extension AdminNewDishPresenter: AdminNewDishPresenterProtocol {

    func viewDidLoad() {
    }
}
