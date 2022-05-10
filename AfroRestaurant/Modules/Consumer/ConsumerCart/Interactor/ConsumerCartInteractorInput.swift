protocol ConsumerCartInteractorInput: AnyObject {
    func removeDishFromCart(dishModel: ConsumerDataBaseService.ConsumerDishMinimalModel, completion: @escaping () -> Void)
    func addDishToCart(dishModel: ConsumerDataBaseService.CartModelMinimal)
    func loadCarts(completion: @escaping ([CartModel]?) -> ())
    func isDishInCart(dishModel: DishModel) -> Bool
}
