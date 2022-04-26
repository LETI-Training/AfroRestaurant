import UIKit 

class SignupRouter {
    weak var view: UIViewController?
    
    func routeBack() {
        view?.navigationController?.popViewController(animated: true)
    }
}
