protocol AdminDishesInteractorInput: AnyObject {
    func loadDishes(for categoryName: String, completion: @escaping ([DishModel]?) -> Void)
    func deleteDish(_ dishName: String, in categoryName: String, completion: @escaping () -> Void)
}
