class AdminInventoryPresenter {
    weak var view: AdminInventoryViewInput?
    var interactor: AdminInventoryInteractorInput?
    var router: AdminInventoryRouter?

    init() {}
}

extension AdminInventoryPresenter: AdminInventoryPresenterProtocol {

    func viewDidLoad() {
    }
}
