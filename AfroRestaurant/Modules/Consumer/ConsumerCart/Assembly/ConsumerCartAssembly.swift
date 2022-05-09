import UIKit

class ConsumerCartAssembly {

    static func assemble() -> UIViewController {
        let view = ConsumerCartViewController()
        let router = ConsumerCartRouter()
        let presenter = ConsumerCartPresenter()
        let interactor = ConsumerCartInteractor()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        router.view = view

        return view
    }

}