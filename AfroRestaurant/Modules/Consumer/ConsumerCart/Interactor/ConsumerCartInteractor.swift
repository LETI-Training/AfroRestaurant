class ConsumerCartInteractor {
    let consumerDataBase: ConsumerDataBaseServiceProtocol
    
    init(consumerDataBase: ConsumerDataBaseServiceProtocol) {
        self.consumerDataBase = consumerDataBase
    }
}

extension ConsumerCartInteractor: ConsumerCartInteractorInput {
    func isDishInCart(dishModel: DishModel) -> Bool {
        consumerDataBase.isDishInCart(dishModel: dishModel)
    }
    
    func loadCarts(completion: @escaping ([CartModel]?) -> ()) {
        consumerDataBase.loadCarts(completion: completion)
    }
    
    func addDishToCart(dishModel: ConsumerDataBaseService.CartModelMinimal) {
        consumerDataBase.updateDishToCart(model: dishModel)
    }
    
    func removeDishFromCart(dishModel: ConsumerDataBaseService.ConsumerDishMinimalModel, completion: @escaping () -> Void) {
        consumerDataBase.removeDishFromCart(dishModel: dishModel, completion: completion)
    }
}

