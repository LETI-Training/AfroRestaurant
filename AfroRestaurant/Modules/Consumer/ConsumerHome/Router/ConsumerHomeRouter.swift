import UIKit 

class ConsumerHomeRouter {
    weak var view: UIViewController?
    
    func routeToDishe(dish: DishModel, categoryName: String) {
        let newVC = ConsumerDishViewAssembly.assemble(dishModel: dish)
        view?.navigationController?.pushViewController(newVC, animated: true)
    }
    
    func moveToCartTab() {
        guard let tabBar = view?.navigationController?.tabBarController else { return }
        
        tabBar.selectedIndex = 2
    }
}
