protocol AdminDishesViewInput: AnyObject {
    func updateTitle(title: String)
    func updateItems(description: String, viewModels: [DishesCollectionViewCell.ViewModel])
    func presentAlert(
        title: String,
        message: String,
        action: ActionAlertModel?,
        action2: ActionAlertModel?
    )
}
