class AdminNewCategoryInteractor {
    let databaseService: DataBaseServiceProtocol?
    
    init(databaseService: DataBaseServiceProtocol?) {
        self.databaseService = databaseService
    }
}

extension AdminNewCategoryInteractor: AdminNewCategoryInteractorInput {
    func createNewCategory(categoryModel: AdminCategoryModel) {
        databaseService?.createNewCategory(categoryModel: categoryModel)
    }
}
