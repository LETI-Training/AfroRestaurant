class AdminNewCategoryPresenter {
    weak var view: AdminNewCategoryViewInput?
    var interactor: AdminNewCategoryInteractorInput?
    var router: AdminNewCategoryRouter?

    init() {}
}

extension AdminNewCategoryPresenter: AdminNewCategoryPresenterProtocol {
    func createCategoryButtonTapped() {
        
    }
    
    func cancelTapped() {
        router?.dismiss()
    }

    func viewDidLoad() {
    }
}
