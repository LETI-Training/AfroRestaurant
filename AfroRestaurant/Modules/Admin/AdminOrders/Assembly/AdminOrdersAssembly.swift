import UIKit

class AdminOrdersAssembly {

    static func assemble() -> UIViewController {
        let view = AdminOrdersViewController()
        let router = AdminOrdersRouter()
        let presenter = AdminOrdersPresenter()
        let interactor = AdminOrdersInteractor()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        router.view = view

        return view
    }

}
