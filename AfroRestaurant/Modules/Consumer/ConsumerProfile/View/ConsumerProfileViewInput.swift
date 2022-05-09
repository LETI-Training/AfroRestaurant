protocol ConsumerProfileViewInput: AnyObject {
    func updateView(model: ConsumerDataBaseService.UserDetails)
    func presentAlert(
        title: String,
        message: String,
        action: ActionAlertModel?,
        action2: ActionAlertModel?
    )
}
