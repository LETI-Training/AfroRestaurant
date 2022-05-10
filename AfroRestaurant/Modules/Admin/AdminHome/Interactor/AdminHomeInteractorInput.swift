protocol AdminHomeInteractorInput: AnyObject {
    var authErrorListner: ((_ errorText: String) -> Void)? { get set }
    var ordersListener: (([AdminAnalyticsDataBaseService.OrderModel]) -> Void)? { get set }
    
    func performLogout()
    func loadOrders()
}
