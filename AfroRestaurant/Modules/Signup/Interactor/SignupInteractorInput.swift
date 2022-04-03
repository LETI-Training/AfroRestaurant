protocol SignupInteractorInput: AnyObject {
    var authErrorListner: ((_ errorText: String) -> Void)? { get set }
    
    func signUp(
        fullName: String,
        email: String,
        password: String,
        phoneNumber: String
    )
}
