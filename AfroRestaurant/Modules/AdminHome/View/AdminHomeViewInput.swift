protocol AdminHomeViewInput: AnyObject {
    func presentAlert(
        title: String,
        message: String,
        action: ActionAlertModel?,
        action2: ActionAlertModel?
    )
    func updateUI(dailyProfits: String, newOrders: String, cancelledOrders: String)
    func updateItems(viewModels: [AdminUpdatesTableViewCell.ViewModel])
}
