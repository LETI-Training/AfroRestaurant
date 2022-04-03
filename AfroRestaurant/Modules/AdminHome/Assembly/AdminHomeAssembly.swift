import UIKit

class AdminHomeAssembly {

    static func assemble() -> UIViewController {
        let view = AdminHomeViewController()
        let router = AdminHomeRouter()
        let presenter = AdminHomePresenter()
        let interactor = AdminHomeInteractor()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        router.view = view

        return view
    }

}
