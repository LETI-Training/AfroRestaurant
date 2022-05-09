class AdminNewDishInteractor {
    let databaseService: AdminDataBaseServiceProtocol?
    
    init(databaseService: AdminDataBaseServiceProtocol?) {
        self.databaseService = databaseService
    }
}

extension AdminNewDishInteractor: AdminNewDishInteractorInput {
    func createNewDish(dishModel: AdminCreateDishModel) {
        databaseService?.addDishToCategory(dishModel: dishModel)
    }
}
