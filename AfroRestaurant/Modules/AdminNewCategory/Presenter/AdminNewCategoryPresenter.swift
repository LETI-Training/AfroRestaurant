class AdminNewCategoryPresenter {
    weak var view: AdminNewCategoryViewInput?
    var interactor: AdminNewCategoryInteractorInput?
    var router: AdminNewCategoryRouter?

    init() {}
}

extension AdminNewCategoryPresenter: AdminNewCategoryPresenterProtocol {

    func viewDidLoad() {
    }
}
