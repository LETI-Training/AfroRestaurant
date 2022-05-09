protocol AdminInventoryViewInput: AnyObject {
    func updateItems(viewModels: [AdminInventoryTableViewCell.ViewModel])
    func presentAlert(
        title: String,
        message: String,
        action: ActionAlertModel?,
        action2: ActionAlertModel?
    )
}
