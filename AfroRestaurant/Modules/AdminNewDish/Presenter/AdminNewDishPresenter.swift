class AdminNewDishPresenter {
    weak var view: AdminNewDishViewInput?
    var interactor: AdminNewDishInteractorInput?
    var router: AdminNewDishRouter?

    let category: AdminCreateCategoryModel
    weak var output: AdminNewDishPresenterOutput?
    
    init(category: AdminCreateCategoryModel, output: AdminNewDishPresenterOutput) {
        self.category = category
        self.output = output
    }
}

extension AdminNewDishPresenter: AdminNewDishPresenterProtocol {
    func addPhotoTapped() {
        
    }
    
    func createDishButtonTapped(dishName: String, description: String, calories: String, price: String) {
        
    }
    
    func cancelTapped() {
        
    }
    

    func viewDidLoad() {
    }
}
