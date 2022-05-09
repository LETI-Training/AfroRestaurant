import UIKit

class ConsumerFavoritesAssembly {

    static func assemble() -> UIViewController {
        let view = ConsumerFavoritesViewController()
        let router = ConsumerFavoritesRouter()
        let presenter = ConsumerFavoritesPresenter()
        let interactor = ConsumerFavoritesInteractor(consumerDataBase: ServiceLocator.shared.getService()!)

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        router.view = view

        return view
    }

}
