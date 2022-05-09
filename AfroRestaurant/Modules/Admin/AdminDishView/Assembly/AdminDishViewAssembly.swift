import UIKit

class AdminDishViewAssembly {

    static func assemble(dishModel: DishModel, categoryName: String) -> UIViewController {
        let view = AdminDishViewViewController()
        let router = AdminDishViewRouter()
        let presenter = AdminDishViewPresenter(dishModel: dishModel, categoryName: categoryName)
        let interactor = AdminDishViewInteractor(databaseService: ServiceLocator.shared.getService())

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        router.view = view

        return view
    }

}
