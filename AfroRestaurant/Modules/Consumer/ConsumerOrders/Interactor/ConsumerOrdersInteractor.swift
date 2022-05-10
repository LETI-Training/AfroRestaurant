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
}
