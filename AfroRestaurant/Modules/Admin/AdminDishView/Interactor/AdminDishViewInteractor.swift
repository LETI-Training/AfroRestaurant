class AdminDishViewInteractor {
    let databaseService: AdminDataBaseServiceProtocol?
    
    init(databaseService: AdminDataBaseServiceProtocol?) {
        self.databaseService = databaseService
    }
}

extension AdminDishViewInteractor: AdminDishViewInteractorInput {
    func deleteDish(_ dishName: String, in categoryName: String, completion: @escaping () -> Void) {
        databaseService?.deleteDish(dishName, in: categoryName, completion: completion)
    }
    
    func updateDishToCategory(dishModel: AdminCreateDishModel) {
        databaseService?.updateDishToCategory(dishModel: dishModel)
    }
    
    func loadDish(dishName: String, for categoryName: String, completion: @escaping (DishModel?) -> Void) {
        databaseService?.loadDish(dishName: dishName, for: categoryName, completion: completion)
    }
}
