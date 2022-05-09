protocol AdminDishViewInteractorInput: AnyObject {
    func deleteDish(_ dishName: String, in categoryName: String, completion: @escaping () -> Void)
    func updateDishToCategory(dishModel: AdminCreateDishModel)
    func loadDish(dishName: String, for categoryName: String, completion: @escaping (DishModel?) -> Void)
}
