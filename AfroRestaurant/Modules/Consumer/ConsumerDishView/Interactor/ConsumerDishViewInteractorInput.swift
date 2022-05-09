protocol ConsumerDishViewInteractorInput: AnyObject {
    func isDishInCart(dishModel: DishModel) -> Bool
    func isDishInFavorites(dishModel: DishModel) -> Bool
    func addDishToFavorite(dishModel: ConsumerDataBaseService.ConsumerDishMinimalModel)
    func addDishToCart(dishModel: ConsumerDataBaseService.CartModelMinimal)
    func removeDishFromFavorite(dishModel: ConsumerDataBaseService.ConsumerDishMinimalModel, completion: @escaping () -> Void)
    func removeDishFromCart(dishModel: ConsumerDataBaseService.ConsumerDishMinimalModel, completion: @escaping () -> Void)
    func loadDish(dishName: String, for categoryName: String, completion: @escaping (DishModel?) -> Void)
}
