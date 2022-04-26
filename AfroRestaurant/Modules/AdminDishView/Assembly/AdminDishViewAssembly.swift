import UIKit

class AdminDishViewAssembly {

    static func assemble() -> UIViewController {
        let view = AdminDishViewViewController()
        let router = AdminDishViewRouter()
        let presenter = AdminDishViewPresenter()
        let interactor = AdminDishViewInteractor()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        router.view = view

        return view
    }

}
