import UIKit

class LoginAssembly {

    static func assemble() -> UIViewController {
        let view = LoginViewController()
        let router = LoginRouter()
        let presenter = LoginPresenter()
        let interactor = LoginInteractor()
        let textManager = LoginTextManager()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.textManager = textManager
        presenter.router = router
        router.view = view

        return view
    }

}
