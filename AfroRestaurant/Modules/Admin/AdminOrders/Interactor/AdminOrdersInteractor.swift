class AdminOrdersInteractor {
    let orderDataBase: AdminAnalyticsDataBaseServiceProtocol
    
    var listener: (([AdminAnalyticsDataBaseService.OrderModel]) -> Void)?
    
    init(orderDataBase: AdminAnalyticsDataBaseServiceProtocol) {
        self.orderDataBase = orderDataBase
        orderDataBase.addListner(self)
    }
}

extension AdminOrdersInteractor: AdminOrdersInteractorInput {
    func updateOrderStatus(status: AdminAnalyticsDataBaseService.OrderStatus, orderNumber: String) {
        orderDataBase.updateOrderStatus(status: status, orderNumber: orderNumber)
    }
    
    func loadOrders() {
        orderDataBase.loadOrders()
    }
}

extension AdminOrdersInteractor: AdminAnalyticsDataBaseServiceOutput {
    func adminService(didFinishLoading orderModels: [AdminAnalyticsDataBaseService.OrderModel]) {
        listener?(orderModels)
    }
}
