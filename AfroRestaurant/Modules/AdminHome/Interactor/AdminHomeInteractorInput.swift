protocol AdminHomeInteractorInput: AnyObject {
    var authErrorListner: ((_ errorText: String) -> Void)? { get set }
    
    func performLogout()
}
