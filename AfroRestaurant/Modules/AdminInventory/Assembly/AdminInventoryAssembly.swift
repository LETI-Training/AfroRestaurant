import UIKit

class AdminInventoryAssembly {

    static func assemble() -> UIViewController {
        let view = AdminInventoryViewController()
        let router = AdminInventoryRouter()
        let presenter = AdminInventoryPresenter()
        let interactor = AdminInventoryInteractor()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        router.view = view

        return view
    }

}
