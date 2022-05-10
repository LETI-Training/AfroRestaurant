protocol ConsumerCartInteractorInput: AnyObject {
    var userDetails: ConsumerDataBaseService.UserDetails? { get }
    
    func removeDishFromCart(dishModel: ConsumerDataBaseService.ConsumerDishMinimalModel, completion: @escaping () -> Void)
    func addDishToCart(dishModel: ConsumerDataBaseService.CartModelMinimal)
    func loadCarts(completion: @escaping ([CartModel]?) -> ())
    func isDishInCart(dishModel: DishModel) -> Bool
    func removeAllDishesFromCart(completion: @escaping () -> Void)
    func createOrder(model: AdminAnalyticsDataBaseService.OrderCreateModel)
}
