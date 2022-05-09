import UIKit

class AdminNewDishAssembly {

    static func assemble(output: AdminNewDishPresenterOutput, category: AdminCreateCategoryModel) -> UIViewController {
        let view = AdminNewDishViewController()
        let router = AdminNewDishRouter()
        let presenter = AdminNewDishPresenter(
            category: category,
            output: output
        )
        let interactor = AdminNewDishInteractor(databaseService: ServiceLocator.shared.getService())

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        router.view = view

        return view
    }

}
