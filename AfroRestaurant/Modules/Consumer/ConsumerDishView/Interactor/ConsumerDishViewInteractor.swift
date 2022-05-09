class ConsumerDishViewInteractor {
    let consumerDataBase: ConsumerDataBaseServiceProtocol
    
    init(consumerDataBase: ConsumerDataBaseServiceProtocol) {
        self.consumerDataBase = consumerDataBase
    }
}

extension ConsumerDishViewInteractor: ConsumerDishViewInteractorInput {
    func loadDish(dishName: String, for categoryName: String, completion: @escaping (DishModel?) -> Void) {
        consumerDataBase.loadDish(dishName: dishName, for: categoryName, completion: completion)
    }
    
    func isDishInCart(dishModel: DishModel) -> Bool {
        consumerDataBase.isDishInCart(dishModel: dishModel)
    }
    
    func isDishInFavorites(dishModel: DishModel) -> Bool {
        consumerDataBase.isDishInFavorites(dishModel: dishModel)
    }
    
    func addDishToFavorite(dishModel: ConsumerDataBaseService.ConsumerDishMinimalModel) {
        consumerDataBase.addDishToFavorite(model: dishModel)
    }
    
    func addDishToCart(dishModel: ConsumerDataBaseService.CartModelMinimal) {
        consumerDataBase.addDishToCart(model: dishModel)
    }
    
    func removeDishFromFavorite(dishModel: ConsumerDataBaseService.ConsumerDishMinimalModel, completion: @escaping () -> Void) {
        consumerDataBase.removeDishFromFavorite(dishModel: dishModel, completion: completion)
    }
    
    func removeDishFromCart(dishModel: ConsumerDataBaseService.ConsumerDishMinimalModel, completion: @escaping () -> Void) {
        consumerDataBase.removeDishFromCart(dishModel: dishModel, completion: completion)
    }
}
