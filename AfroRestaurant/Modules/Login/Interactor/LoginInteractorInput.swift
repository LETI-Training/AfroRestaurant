protocol LoginInteractorInput: AnyObject {
    func signIn(email: String, password: String)
    func resetPassword(email: String)
    
    var authErrorListner: ((_ errorText: String) -> Void)? { get set }
}
