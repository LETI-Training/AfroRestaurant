protocol AdminDishViewInteractorInput: AnyObject {
    func deleteDish(_ dishName: String, in categoryName: String, completion: @escaping () -> Void)
    func updateDishToCategory(dishModel: AdminCreateDishModel)
    func loadDish(dishName: String, for categoryName: String, completion: @escaping (DishModel?) -> Void)
    func loadLikesCount(dishname: String, in categoryName: String)
    func loadRatingsCount(dishName: String, in categoryName: String)
    var likesListener: ((_ likesCount: Int, _ dishName: String, _ categoryName: String) -> Void)? { get set }
    var ratingsListener: ((_ ratingsAverage: Double, _ dishName: String, _ categoryName: String) -> Void)? { get set }
}
