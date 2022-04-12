import UIKit

class AdminDishesAssembly {

    static func assemble() -> UIViewController {
        let view = AdminDishesViewController()
        let router = AdminDishesRouter()
        let presenter = AdminDishesPresenter()
        let interactor = AdminDishesInteractor()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        router.view = view

        return view
    }

}
