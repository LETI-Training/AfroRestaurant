protocol SignupPresenterProtocol: AnyObject {
    func viewDidLoad()
    
    func didTapCreateAccountButton(
        name: String?,
        email: String?,
        password: String?,
        passwordVerify: String?,
        phoneNumber: String?
    )
    
    func didTapLogInLabel()
}
