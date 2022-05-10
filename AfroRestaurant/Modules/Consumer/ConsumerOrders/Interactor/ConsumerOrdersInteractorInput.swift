protocol ConsumerOrdersInteractorInput: AnyObject {
    var listener: (([AdminAnalyticsDataBaseService.OrderModel]) -> Void)? { get set }
    func loadOrders()
    func updateOrderStatus(status: AdminAnalyticsDataBaseService.OrderStatus, orderNumber: String)
}
