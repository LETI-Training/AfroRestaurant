import UIKit 

class ConsumerDishViewRouter {
    weak var view: UIViewController?
    
    func moveToCartTab() {
        guard let tabBar = view?.navigationController?.tabBarController else { return }
        
        tabBar.selectedIndex = 2
    }
}
