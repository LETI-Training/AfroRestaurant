import UIKit 

class AdminNewCategoryRouter {
    weak var view: UIViewController?
    
    func dismiss() {
        view?.navigationController?.dismiss(animated: true, completion: nil)
    }
}
