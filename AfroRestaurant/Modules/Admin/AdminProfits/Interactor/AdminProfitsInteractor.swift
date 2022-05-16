class AdminProfitsInteractor {
    private let orderDataBase: AdminAnalyticsDataBaseServiceProtocol
    var ordersListener: (([AdminAnalyticsDataBaseService.OrderModel]) -> Void)?
    
    init(
        orderDataBase: AdminAnalyticsDataBaseServiceProtocol
    ) {
        self.orderDataBase = orderDataBase
        
        orderDataBase.addListner(self)
    }
    
    deinit {
        orderDataBase.removeListner(self)
    }
}

extension AdminProfitsInteractor: AdminProfitsInteractorInput {
    func loadOrders() {
        orderDataBase.loadOrders()
    }
}

extension AdminProfitsInteractor: AdminAnalyticsDataBaseServiceOutput {
    func adminService(didFinishLoading orderModels: [AdminAnalyticsDataBaseService.OrderModel]) {
        ordersListener?(orderModels)
    }
    
    func adminService(didFinishLoadingLikes likesCount: Int, for dishName: String, in categoryName: String) {}
    
    func adminService(didFinishLoadingRatings ratingsAverage: Double, for dishName: String, in categoryName: String) {}
    
    func adminService(didFinishLoadingRatingsForRestaurant ratingsAverage: Double) {}
    
    func adminService(didFinishLoadingUserDetails: UserDetails) {}
    
    func adminService(didFinishLoadingAllUpdates: [UpdateModel]) {}
}
