import UIKit

class AdminHomeAssembly {

    static func assemble() -> UIViewController {
        let view = AdminHomeViewController()
        let router = AdminHomeRouter()
        let presenter = AdminHomePresenter()
        let authService: AuthorizationServiceInput? = ServiceLocator.shared.getService()
        let interactor = AdminHomeInteractor(authService: authService, orderDataBase: ServiceLocator.shared.getService()!)

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        router.view = view

        return view
    }

}
