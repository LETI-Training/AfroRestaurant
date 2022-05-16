protocol ConsumerDishViewInteractorInput: AnyObject {
    func isDishInCart(dishModel: DishModel) -> Bool
    func isDishInFavorites(dishModel: DishModel) -> Bool
    func addDishToFavorite(dishModel: ConsumerDataBaseService.ConsumerDishMinimalModel)
    func addDishToCart(dishModel: ConsumerDataBaseService.CartModelMinimal)
    func removeDishFromFavorite(dishModel: ConsumerDataBaseService.ConsumerDishMinimalModel, completion: @escaping () -> Void)
    func removeDishFromCart(dishModel: ConsumerDataBaseService.ConsumerDishMinimalModel, completion: @escaping () -> Void)
    func loadDish(dishName: String, for categoryName: String, completion: @escaping (DishModel?) -> Void)
    func rateDish(rating: Double, dishname: String, categoryName: String)
    func loadLikesCount(dishname: String, in categoryName: String)
    func loadRatingsCount(dishName: String, in categoryName: String)
    
    var likesListener: ((_ likesCount: Int, _ dishName: String, _ categoryName: String) -> Void)? { get set }
    var ratingsListener: ((_ ratingsAverage: Double, _ dishName: String, _ categoryName: String) -> Void)? { get set }
}
