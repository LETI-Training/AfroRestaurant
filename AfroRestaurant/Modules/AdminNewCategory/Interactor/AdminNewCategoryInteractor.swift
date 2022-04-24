class AdminNewCategoryInteractor {
    let databaseService: AdminDataBaseServiceProtocol?
    
    init(databaseService: AdminDataBaseServiceProtocol?) {
        self.databaseService = databaseService
    }
}

extension AdminNewCategoryInteractor: AdminNewCategoryInteractorInput {
    func createNewCategory(categoryModel: AdminCreateCategoryModel) {
        databaseService?.createNewCategory(categoryModel: categoryModel)
    }
}
