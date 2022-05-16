protocol ConsumerDishViewViewInput: AnyObject {
    func updateUI(model: DishModel, viewModel: ConsumerDishViewViewController.ViewModel)
    func updateLikes(likesCount: Int)
    func updateRatings(rating: Double)
}
