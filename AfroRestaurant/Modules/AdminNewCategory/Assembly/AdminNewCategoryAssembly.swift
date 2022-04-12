import UIKit

class AdminNewCategoryAssembly {

    static func assemble(output: AdminNewCategoryPresenterOutput) -> UIViewController {
        let view = AdminNewCategoryViewController()
        let router = AdminNewCategoryRouter()
        let presenter = AdminNewCategoryPresenter(output: output)
        let interactor = AdminNewCategoryInteractor(databaseService: ServiceLocator.shared.getService())

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        router.view = view

        return view
    }

}
