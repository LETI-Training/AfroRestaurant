import UIKit 

class AdminDishesRouter {
    weak var view: UIViewController?
    
    func presentNewDish(output: AdminNewDishPresenterOutput, category: AdminCreateCategoryModel) {
        let newVC = AdminNewDishAssembly.assemble(output: output, category: category)
        newVC.title = "New Dish"
        view?.navigationController?.present(UINavigationController(rootViewController: newVC), animated: true, completion: nil)
    }
    
    func routeToDishe(category: DishModel) {
        let newVC = AdminDishViewAssembly.assemble()
        view?.navigationController?.pushViewController(newVC, animated: true)
    }
}
