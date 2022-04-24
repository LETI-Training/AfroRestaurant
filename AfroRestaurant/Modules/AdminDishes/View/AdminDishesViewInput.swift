protocol AdminDishesViewInput: AnyObject {
    func updateItems(description: String, viewModels: [DishesCollectionViewCell.ViewModel])
    func presentAlert(
        title: String,
        message: String,
        action: ActionAlertModel?,
        action2: ActionAlertModel?
    )
}
