class AdminDishViewPresenter {
    weak var view: AdminDishViewViewInput?
    var interactor: AdminDishViewInteractorInput?
    var router: AdminDishViewRouter?

    init() {}
}

extension AdminDishViewPresenter: AdminDishViewPresenterProtocol {

    func viewDidLoad() {
    }
}
