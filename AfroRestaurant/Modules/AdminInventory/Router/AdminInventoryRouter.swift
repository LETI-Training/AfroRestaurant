import UIKit 

class AdminInventoryRouter {
    weak var view: UIViewController?
    
    func presentNewCategory() {
        let newVC = AdminNewCategoryAssembly.assemble()
        newVC.title = "New Category"
        view?.navigationController?.present(UINavigationController(rootViewController: newVC), animated: true, completion: nil)
    }
}
