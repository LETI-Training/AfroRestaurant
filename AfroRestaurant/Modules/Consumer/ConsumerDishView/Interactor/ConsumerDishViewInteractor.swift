class ConsumerDishViewInteractor {
    let consumerDataBase: ConsumerDataBaseServiceProtocol
    let ordersService: AdminAnalyticsDataBaseServiceProtocol
    var likesListener: ((_ likesCount: Int, _ dishName: String, _ categoryName: String) -> Void)?
    var ratingsListener: ((_ ratingsAverage: Double, _ dishName: String, _ categoryName: String) -> Void)?
    
    init(consumerDataBase: ConsumerDataBaseServiceProtocol, ordersService: AdminAnalyticsDataBaseServiceProtocol) {
        self.consumerDataBase = consumerDataBase
        self.ordersService = ordersService
        ordersService.addListner(self)
    }
    
    deinit {
        ordersService.removeListner(self)
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
    
    func rateDish(rating: Double, dishname: String, categoryName: String) {
        ordersService.rateDish(rating: rating, dishname: dishname, categoryName: categoryName)
    }
    
    func loadLikesCount(dishname: String, in categoryName: String) {
        ordersService.loadLikesCount(dishname: dishname, in: categoryName)
    }
    
    func loadRatingsCount(dishName: String, in categoryName: String) {
        ordersService.loadRatingsCount(dishName: dishName, in: categoryName)
    }
}


extension ConsumerDishViewInteractor: AdminAnalyticsDataBaseServiceOutput {
    func adminService(didFinishLoading orderModels: [AdminAnalyticsDataBaseService.OrderModel]) {}
    
    func adminService(didFinishLoadingLikes likesCount: Int, for dishName: String, in categoryName: String) {
        likesListener?(likesCount, dishName, categoryName)
    }
    
    func adminService(didFinishLoadingRatings ratingsAverage: Double, for dishName: String, in categoryName: String) {
        ratingsListener?(ratingsAverage, dishName, categoryName)
    }
    
    func adminService(didFinishLoadingRatingsForRestaurant ratingsAverage: Double) {}
    
    func adminService(didFinishLoadingUserDetails: UserDetails) {}
    
    func adminService(didFinishLoadingAllUpdates: [UpdateModel]) {}
}
