class ConsumerHomeInteractor {
    let consumerDataBase: ConsumerDataBaseServiceProtocol
    
    init(consumerDataBase: ConsumerDataBaseServiceProtocol) {
        self.consumerDataBase = consumerDataBase
    }
}

extension ConsumerHomeInteractor: ConsumerHomeInteractorInput {
    func isDishInCart(dishModel: DishModel) -> CartModel? {
        consumerDataBase.isDishInCart(dishModel: dishModel)
    }
    
    func isDishInFavorites(dishModel: DishModel) -> Bool {
        consumerDataBase.isDishInFavorites(dishModel: dishModel)
    }
    
    func addDishToFavorite(dishModel: DishModel) {
        consumerDataBase.addDishToFavorite(dishModel: dishModel)
    }
    
    func addDishToCart(dishModel: DishModel, quantity: Int) {
        consumerDataBase.addDishToCart(dishModel: dishModel, quantity: quantity)
    }
    
    func removeDishFromFavorite(dishModel: DishModel, completion: @escaping () -> Void) {
        consumerDataBase.removeDishFromFavorite(dishModel: dishModel, completion: completion)
    }
    
    func removeDishFromCart(dishModel: DishModel, completion: @escaping () -> Void) {
        consumerDataBase.removeDishFromCart(dishModel: dishModel, completion: completion)
    }
    
    func loadCategories(completion: @escaping ([CategoryModel]?) -> ()) {
        consumerDataBase.loadCategories(completion: completion)
    }
}
