import UIKit

class AdminProfitsAssembly {

    static func assemble() -> UIViewController {
        let view = AdminProfitsViewController()
        let router = AdminProfitsRouter()
        let presenter = AdminProfitsPresenter()
        let interactor = AdminProfitsInteractor(orderDataBase: ServiceLocator.shared.getService()!)

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        router.view = view

        return view
    }

}
