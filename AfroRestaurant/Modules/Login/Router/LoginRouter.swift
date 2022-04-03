import UIKit 

class LoginRouter {
    weak var view: UIViewController?
    
    func routeToSignupPage() {
        let signupVC = SignupAssembly.assemble()
        view?.navigationController?.pushViewController(signupVC, animated: true)
    }
}
