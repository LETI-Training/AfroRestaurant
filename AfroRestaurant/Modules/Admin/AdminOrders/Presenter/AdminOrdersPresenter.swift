class AdminOrdersPresenter {
    weak var view: AdminOrdersViewInput?
    var interactor: AdminOrdersInteractorInput?
    var router: AdminOrdersRouter?

    init() {}
}

extension AdminOrdersPresenter: AdminOrdersPresenterProtocol {

    func viewDidLoad() {
    }
}
