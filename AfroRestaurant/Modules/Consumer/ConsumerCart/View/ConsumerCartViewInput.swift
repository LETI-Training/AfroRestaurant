protocol ConsumerCartViewInput: AnyObject {
    func updateItems(viewModels: [ConsumerCartViewController.ViewModel], cartCount: Int)
    func presentAlert(
        title: String,
        message: String,
        action: ActionAlertModel?,
        action2: ActionAlertModel?
    )
}
