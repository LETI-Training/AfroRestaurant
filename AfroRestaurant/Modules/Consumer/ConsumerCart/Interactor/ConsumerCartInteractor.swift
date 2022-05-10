class ConsumerCartInteractor {
    let consumerDataBase: ConsumerDataBaseServiceProtocol
    let orderDataBase: AdminAnalyticsDataBaseServiceProtocol
    
    var userDetails: ConsumerDataBaseService.UserDetails?
    
    init(
        consumerDataBase: ConsumerDataBaseServiceProtocol,
        orderDataBase: AdminAnalyticsDataBaseServiceProtocol
    ) {
        self.consumerDataBase = consumerDataBase
        self.orderDataBase = orderDataBase
        
        consumerDataBase.getUserDetails { [weak self] userDetails in
            self?.userDetails = userDetails ?? ConsumerDataBaseService.UserDetails(
                userName: "",
                address: "",
                phoneNumber: "",
                email: ""
            )
        }
    }
}

extension ConsumerCartInteractor: ConsumerCartInteractorInput {
    func removeAllDishesFromCart(completion: @escaping () -> Void) {
        consumerDataBase.removeAllDishesFromCart(completion: completion)
    }
    
    func createOrder(model: AdminAnalyticsDataBaseService.OrderCreateModel) {
        orderDataBase.createOrder(model: model)
    }
    
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
