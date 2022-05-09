class AdminNewCategoryPresenter {
    weak var view: AdminNewCategoryViewInput?
    var interactor: AdminNewCategoryInteractorInput?
    var router: AdminNewCategoryRouter?
    
    weak var output: AdminNewCategoryPresenterOutput?
    
    init(output: AdminNewCategoryPresenterOutput) {
        self.output = output
    }
}

extension AdminNewCategoryPresenter: AdminNewCategoryPresenterProtocol {
    func createCategoryButtonTapped(categoryName: String?, categoryDescription: String?) {
        guard
            let categoryName = categoryName,
            let categoryDescription = categoryDescription,
            !categoryName.isEmpty,
            !categoryDescription.isEmpty else {
                view?.presentAlert(
                    title: "Error",
                    message: "Please Fill All Fields",
                    action: .init(actionText: "Ok", actionHandler: {})
                )
                return
            }
        
        interactor?
            .createNewCategory(categoryModel: .init(categoryName: categoryName, categoryDescription: categoryDescription))
        output?.didCreateNewCategory()
        router?.dismiss()
    }
    
    func cancelTapped() {
        router?.dismiss()
    }
    
    func viewDidLoad() {}
}
