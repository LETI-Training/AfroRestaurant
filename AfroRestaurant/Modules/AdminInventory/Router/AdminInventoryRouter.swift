import UIKit 

class AdminInventoryRouter {
    weak var view: UIViewController?
    
    func presentNewCategory(output: AdminNewCategoryPresenterOutput) {
        let newVC = AdminNewCategoryAssembly.assemble(output: output)
        newVC.title = "New Category"
        view?.navigationController?.present(UINavigationController(rootViewController: newVC), animated: true, completion: nil)
    }
    
    func routeToDishes(category: AdminCreateCategoryModel) {
        let newVC = AdminDishesAssembly.assemble(category: category)
        view?.navigationController?.pushViewController(newVC, animated: true)
    }
}
