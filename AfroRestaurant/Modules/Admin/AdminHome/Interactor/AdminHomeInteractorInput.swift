protocol AdminHomeInteractorInput: AnyObject {
    var authErrorListner: ((_ errorText: String) -> Void)? { get set }
    var ordersListener: (([AdminAnalyticsDataBaseService.OrderModel]) -> Void)? { get set }
    var updatesListener: (([UpdateModel]) -> Void)? { get set }
    var restaurantRatingListener: ((Double) -> Void)? { get set }
    
    func performLogout()
    func loadOrders()
    func loadAllUpdates()
    func loadRestaurantRating()
}
