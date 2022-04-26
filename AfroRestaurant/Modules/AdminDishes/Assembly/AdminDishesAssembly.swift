import UIKit

class AdminDishesAssembly {

    static func assemble(category: CategoryModel) -> UIViewController {
        let view = AdminDishesViewController()
        let router = AdminDishesRouter()
        let presenter = AdminDishesPresenter(category: category)
        let interactor = AdminDishesInteractor(databaseService: ServiceLocator.shared.getService())

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        router.view = view

        return view
    }

}
