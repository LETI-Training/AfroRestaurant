import UIKit 

class AdminProfitsRouter {
    weak var view: UIViewController?
    
    func routeToOrders(filterType: AdminOrdersPresenter.OrderFilterType) {
        let newVC = AdminOrdersAssembly.assemble(filterType: filterType)
        view?.navigationController?.pushViewController(newVC, animated: true)
    }
}
