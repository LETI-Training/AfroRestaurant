protocol AdminProfitsInteractorInput: AnyObject {
    func loadOrders()
    var ordersListener: (([AdminAnalyticsDataBaseService.OrderModel]) -> Void)? { get set }
}
