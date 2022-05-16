protocol ConsumerDishViewViewInput: AnyObject {
    func updateUI(model: DishModel, viewModel: ConsumerDishViewViewController.ViewModel)
    func updateLikes(likesCount: Int)
    func updateRatings(rating: Double)
    func presentAlertWithTextField(
        title: String,
        actionCancel: ActionAlertModel?,
        actionComplete: ActionAlertModel?,
        placeHolder: String,
        completion: @escaping (String) -> ()
    )
    func presentAlert(title: String, message: String, action: ActionAlertModel?)
}
