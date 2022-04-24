class AdminInventoryPresenter {
    weak var view: AdminInventoryViewInput?
    var interactor: AdminInventoryInteractorInput?
    var router: AdminInventoryRouter?
    
    var categoryModels: [CategoryModel] = []

    init() {}
    
    private func loadCategories() {
        interactor?.loadCategories(completion: { [weak self] models in
            self?.createViewModels(from: models)
        })
    }
    
    private func createViewModels(from categoryModels: [CategoryModel]?) {
        guard let categoryModels = categoryModels else {
            return
        }
        let viewModels = categoryModels
            .compactMap { AdminInventoryTableViewCell.ViewModel(categoryName: $0.categoryName) }
        self.categoryModels = categoryModels
        view?.updateItems(viewModels: viewModels)
    }
}

extension AdminInventoryPresenter: AdminInventoryPresenterProtocol {
    func didTapAddNewCategory() {
        router?.presentNewCategory(output: self)
    }
    
    func didSelectItem(at row: Int) {
        router?.routeToDishes(
            category: categoryModels[row]
        )
    }
    
    func didDeleteItem(at row: Int) {
        interactor?.deleteCategory(categoryModel: categoryModels[row], completion: { [weak self] in
            self?.loadCategories()
        })
    }
    
    func viewDidAppear() {
        loadCategories()
    }

    func viewDidLoad() {
        loadCategories()
    }
}

extension AdminInventoryPresenter: AdminNewCategoryPresenterOutput {
    func didCreateNewCategory() {
        loadCategories()
    }
}
