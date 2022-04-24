class AdminInventoryInteractor {
    let databaseService: AdminDataBaseServiceProtocol?
    
    init(databaseService: AdminDataBaseServiceProtocol?) {
        self.databaseService = databaseService
    }
}

extension AdminInventoryInteractor: AdminInventoryInteractorInput {
    func loadCategories(completion: @escaping ([CategoryModel]?) -> ()) {
        databaseService?.loadCategories(completion: completion)
    }
    
    func deleteCategory(categoryModel: CategoryModel, completion: @escaping () -> Void) {
        databaseService?.deleteCategory(categoryModel: categoryModel, completion: completion)
    }
}
