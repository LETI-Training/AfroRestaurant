import UIKit 

class AdminDishesRouter {
    weak var view: UIViewController?
    
    func presentNewDish(output: AdminNewDishPresenterOutput, category: AdminCreateCategoryModel) {
        let newVC = AdminNewDishAssembly.assemble(output: output, category: category)
        newVC.title = "New Dish"
        view?.navigationController?.present(UINavigationController(rootViewController: newVC), animated: true, completion: nil)
    }
    
    func routeToDishe(dish: DishModel, categoryName: String) {
        let newVC = AdminDishViewAssembly.assemble(dishModel: dish, categoryName: categoryName)
        view?.navigationController?.pushViewController(newVC, animated: true)
    }
}
