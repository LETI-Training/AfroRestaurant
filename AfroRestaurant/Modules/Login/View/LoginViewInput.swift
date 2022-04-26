protocol LoginViewInput: AnyObject {
    func presentAlert(title: String, message: String, action: ActionAlertModel?)
}
