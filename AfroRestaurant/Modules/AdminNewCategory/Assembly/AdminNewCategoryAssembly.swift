import UIKit

class AdminNewCategoryAssembly {

    static func assemble() -> UIViewController {
        let view = AdminNewCategoryViewController()
        let router = AdminNewCategoryRouter()
        let presenter = AdminNewCategoryPresenter()
        let interactor = AdminNewCategoryInteractor()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        router.view = view

        return view
    }

}
