import UIKit

class ConsumerMapAssembly {

    static func assemble() -> UIViewController {
        let view = ConsumerMapViewController()
        let router = ConsumerMapRouter()
        let presenter = ConsumerMapPresenter()
        let interactor = ConsumerMapInteractor()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        router.view = view

        return view
    }

}
