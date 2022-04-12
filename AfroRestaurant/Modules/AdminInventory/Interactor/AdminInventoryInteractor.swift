class AdminInventoryInteractor {
    let databaseService: DataBaseServiceProtocol?
    
    init(databaseService: DataBaseServiceProtocol?) {
        self.databaseService = databaseService
    }
}

extension AdminInventoryInteractor: AdminInventoryInteractorInput {
    func loadCategories(completion: @escaping ([AdminCategoryModel]?) -> ()) {
        databaseService?.loadCategories(completion: completion)
    }
    
    func deleteCategory(categoryModel: AdminCategoryModel, completion: @escaping () -> Void) {
        databaseService?.deleteCategory(categoryModel: categoryModel, completion: completion)
    }
}
