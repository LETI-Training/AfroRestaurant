import UIKit

class AdminNewDishAssembly {

    static func assemble() -> UIViewController {
        let view = AdminNewDishViewController()
        let router = AdminNewDishRouter()
        let presenter = AdminNewDishPresenter()
        let interactor = AdminNewDishInteractor()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        router.view = view

        return view
    }

}
