class AdminNewCategoryInteractor {
    let databaseService: AdminDataBaseServiceProtocol?
    
    init(databaseService: AdminDataBaseServiceProtocol?) {
        self.databaseService = databaseService
    }
}

extension AdminNewCategoryInteractor: AdminNewCategoryInteractorInput {
    func createNewCategory(categoryModel: AdminCategoryModel) {
        databaseService?.createNewCategory(categoryModel: categoryModel)
    }
}
