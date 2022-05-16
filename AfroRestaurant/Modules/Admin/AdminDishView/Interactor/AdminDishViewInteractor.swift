class AdminDishViewInteractor {
    let databaseService: AdminDataBaseServiceProtocol?
    let ordersService: AdminAnalyticsDataBaseServiceProtocol
    
    var likesListener: ((_ likesCount: Int, _ dishName: String, _ categoryName: String) -> Void)?
    var ratingsListener: ((_ ratingsAverage: Double, _ dishName: String, _ categoryName: String) -> Void)?
    
    init(databaseService: AdminDataBaseServiceProtocol?, ordersService: AdminAnalyticsDataBaseServiceProtocol) {
        self.databaseService = databaseService
        self.ordersService = ordersService
        
        ordersService.addListner(self)
    }
    
    deinit {
        ordersService.removeListner(self)
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

extension AdminDishViewInteractor: AdminAnalyticsDataBaseServiceOutput {
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
