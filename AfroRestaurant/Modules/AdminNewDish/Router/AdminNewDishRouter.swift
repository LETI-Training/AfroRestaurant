import UIKit 

class AdminNewDishRouter {
    weak var view: UIViewController?
    
    func dismiss() {
        view?.navigationController?.dismiss(animated: true, completion: nil)
    }
}
