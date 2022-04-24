protocol AdminDishesInteractorInput: AnyObject {
    func loadDishes(for categoryName: String, completion: @escaping ([DishModel]?) -> Void)
}
