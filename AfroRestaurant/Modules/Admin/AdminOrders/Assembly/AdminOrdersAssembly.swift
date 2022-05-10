import UIKit

class AdminOrdersAssembly {

    static func assemble(filterType: AdminOrdersPresenter.OrderFilterType) -> UIViewController {
        let view = AdminOrdersViewController()
        let router = AdminOrdersRouter()
        let presenter = AdminOrdersPresenter(filterType: filterType)
        let interactor = AdminOrdersInteractor(orderDataBase: ServiceLocator.shared.getService()!)

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        router.view = view

        return view
    }

}
