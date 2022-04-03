protocol LoginPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapOnSignInButton(email: String?, password: String?)
    func didTapOnForgetPassword()
    func didTapOnCreateNewAccount()
}
