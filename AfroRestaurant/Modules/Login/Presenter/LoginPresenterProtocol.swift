protocol LoginPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapOnSignInButton(email: String?, password: String?)
    func didTapOnForgetPassword(email: String)
    func didTapOnCreateNewAccount()
}
