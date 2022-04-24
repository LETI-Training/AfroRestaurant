class AdminDishesInteractor {
    let databaseService: AdminDataBaseServiceProtocol?
    
    init(databaseService: AdminDataBaseServiceProtocol?) {
        self.databaseService = databaseService
    }
}

extension AdminDishesInteractor: AdminDishesInteractorInput {
    func loadDishes(for categoryName: String, completion: @escaping ([DishModel]?) -> Void) {
        databaseService?.loadDishes(for: categoryName, completion: completion)
    }
}
