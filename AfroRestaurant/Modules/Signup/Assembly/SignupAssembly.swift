import UIKit

class SignupAssembly {

    static func assemble() -> UIViewController {
        let view = SignupViewController()
        let router = SignupRouter()
        let presenter = SignupPresenter()
        let authService: AuthorizationServiceInput? = ServiceLocator.shared.getService()
        let interactor = SignupInteractor(authService: authService)

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        router.view = view

        return view
    }

}
