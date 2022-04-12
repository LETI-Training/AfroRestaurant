class AdminInventoryPresenter {
    weak var view: AdminInventoryViewInput?
    var interactor: AdminInventoryInteractorInput?
    var router: AdminInventoryRouter?

    init() {}
}

extension AdminInventoryPresenter: AdminInventoryPresenterProtocol {
    func didTapAddNewCategory() {
        router?.presentNewCategory()
    }
    
    func didSelectItem(at row: Int) {
        
    }
    
    func didDeleteItem(at row: Int) {
        
    }
    

    func viewDidLoad() {
        view?.updateItems(viewModels: [
            .init(categoryName: "kekek"),
            .init(categoryName: "kekek"),
            .init(categoryName: "kekek"),
            .init(categoryName: "kekek"),
            .init(categoryName: "kekek"),
            .init(categoryName: "kekek"),
            .init(categoryName: "kekek"),
            .init(categoryName: "kekek"),
            .init(categoryName: "kekek"),
            .init(categoryName: "kekek"),
            .init(categoryName: "kekek"),
            .init(categoryName: "kekek"),
            .init(categoryName: "kekek"),
            .init(categoryName: "kekek"),
            .init(categoryName: "kekek"),
            .init(categoryName: "kekek"),
            .init(categoryName: "kekek"),
            .init(categoryName: "kekek"),
            .init(categoryName: "kekek"),
            .init(categoryName: "kekek"),
            .init(categoryName: "kekek"),
            .init(categoryName: "kekek"),
            .init(categoryName: "kekek"),
            .init(categoryName: "kekek"),
            .init(categoryName: "kekek"),
            .init(categoryName: "kekek"),
            .init(categoryName: "kekek"),
            .init(categoryName: "kekek"),
            .init(categoryName: "kekek"),
            .init(categoryName: "kekek"),
            .init(categoryName: "kekek"),
            .init(categoryName: "kekek"),
            .init(categoryName: "kekek"),
            .init(categoryName: "kekek"),
            .init(categoryName: "kekek"),
            .init(categoryName: "kekek"),
            .init(categoryName: "kekek"),
            .init(categoryName: "kekek")
        ])
    }
}
