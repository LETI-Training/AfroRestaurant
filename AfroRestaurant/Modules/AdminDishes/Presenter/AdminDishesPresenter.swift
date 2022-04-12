class AdminDishesPresenter {
    weak var view: AdminDishesViewInput?
    var interactor: AdminDishesInteractorInput?
    var router: AdminDishesRouter?

    init() {}
}

extension AdminDishesPresenter: AdminDishesPresenterProtocol {

    func viewDidLoad() {
    }
}
