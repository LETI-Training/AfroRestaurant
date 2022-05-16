class ConsumerOrdersInteractor {
    let orderDataBase: AdminAnalyticsDataBaseServiceProtocol
    
    var listener: (([AdminAnalyticsDataBaseService.OrderModel]) -> Void)?
    
    init(orderDataBase: AdminAnalyticsDataBaseServiceProtocol) {
        self.orderDataBase = orderDataBase
        orderDataBase.addListner(self)
    }
    
    deinit {
        orderDataBase.removeListner(self)
    }
}

extension ConsumerOrdersInteractor: ConsumerOrdersInteractorInput {
    func updateOrderStatus(status: AdminAnalyticsDataBaseService.OrderStatus, orderNumber: String) {
        orderDataBase.updateOrderStatus(status: status, orderNumber: orderNumber)
    }
    
    func loadOrders() {
        orderDataBase.loadOrdersForCurrentUser()
    }
}

extension ConsumerOrdersInteractor: AdminAnalyticsDataBaseServiceOutput {
    func adminService(didFinishLoading orderModels: [AdminAnalyticsDataBaseService.OrderModel]) {
        listener?(orderModels)
    }
    
    func adminService(didFinishLoadingLikes likesCount: Int, for dishName: String, in categoryName: String) {}
    
    func adminService(didFinishLoadingRatings ratingsAverage: Double, for dishName: String, in categoryName: String) {}
    
    func adminService(didFinishLoadingRatingsForRestaurant ratingsAverage: Double) {}
    
    func adminService(didFinishLoadingUserDetails: UserDetails) {}
    
    func adminService(didFinishLoadingAllUpdates: [UpdateModel]) {}
}
