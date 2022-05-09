protocol ConsumerProfilePresenterProtocol: AnyObject {
    func viewDidLoad()
    func saveButtonPressed(
        name: String,
        phoneNumber: String,
        address: String
    )
    func logoutTapped()
}
