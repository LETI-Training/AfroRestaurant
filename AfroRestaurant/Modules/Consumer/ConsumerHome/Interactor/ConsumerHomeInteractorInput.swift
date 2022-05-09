protocol ConsumerHomeInteractorInput: AnyObject {
    func loadCategories(completion: @escaping ([CategoryModel]?) -> ())
    func isDishInCart(dishModel: DishModel) -> CartModel?
    func isDishInFavorites(dishModel: DishModel) -> Bool
    func addDishToFavorite(dishModel: DishModel)
    func addDishToCart(dishModel: DishModel, quantity: Int)
    func removeDishFromFavorite(dishModel: DishModel, completion: @escaping () -> Void)
    func removeDishFromCart(dishModel: DishModel, completion: @escaping () -> Void)
}
