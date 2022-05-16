class ConsumerCartInteractor {
    let consumerDataBase: ConsumerDataBaseServiceProtocol
    let orderDataBase: AdminAnalyticsDataBaseServiceProtocol
    
    private(set) var userDetails: ConsumerDataBaseService.UserDetails?
    
    init(
        consumerDataBase: ConsumerDataBaseServiceProtocol,
        orderDataBase: AdminAnalyticsDataBaseServiceProtocol
    ) {
        self.consumerDataBase = consumerDataBase
        self.orderDataBase = orderDataBase
        orderDataBase.addListner(self)
        
        consumerDataBase.getUserDetails { [weak self] userDetails in
            self?.userDetails = userDetails
        }
    }
    
    deinit {
        orderDataBase.removeListner(self)
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

extension ConsumerCartInteractor: AdminAnalyticsDataBaseServiceOutput {
    func adminService(didFinishLoading orderModels: [AdminAnalyticsDataBaseService.OrderModel]) {}
    
    func adminService(didFinishLoadingLikes likesCount: Int, for dishName: String, in categoryName: String) {}
    
    func adminService(didFinishLoadingRatings ratingsAverage: Double, for dishName: String, in categoryName: String) {}
    
    func adminService(didFinishLoadingRatingsForRestaurant ratingsAverage: Double) {}
    
    func adminService(didFinishLoadingUserDetails: UserDetails) {
        self.userDetails = didFinishLoadingUserDetails
    }
    
    func adminService(didFinishLoadingAllUpdates: [UpdateModel]) {}
}
