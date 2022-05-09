import UIKit

class ConsumerHomeAssembly {

    static func assemble() -> UIViewController {
        let view = ConsumerHomeViewController()
        let router = ConsumerHomeRouter()
        let presenter = ConsumerHomePresenter()
        let interactor = ConsumerHomeInteractor(consumerDataBase: ServiceLocator.shared.getService()!)

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        router.view = view

        return view
    }

}
