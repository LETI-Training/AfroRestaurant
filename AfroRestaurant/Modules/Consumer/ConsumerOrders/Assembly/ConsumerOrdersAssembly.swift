import UIKit

class ConsumerOrdersAssembly {

    static func assemble() -> UIViewController {
        let view = ConsumerOrdersViewController()
        let router = ConsumerOrdersRouter()
        let presenter = ConsumerOrdersPresenter()
        let interactor = ConsumerOrdersInteractor(orderDataBase: ServiceLocator.shared.getService()!)

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        router.view = view

        return view
    }

}
