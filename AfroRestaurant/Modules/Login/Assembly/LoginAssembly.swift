import UIKit

class LoginAssembly {

    static func assemble() -> UIViewController {
        let view = LoginViewController()
        let router = LoginRouter()
        let presenter = LoginPresenter()
        let authService: AuthorizationServiceInput? = ServiceLocator.shared.getService()
        let interactor = LoginInteractor(authService: authService)

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        router.view = view

        return view
    }

}
