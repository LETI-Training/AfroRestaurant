import UIKit

class ConsumerProfileAssembly {

    static func assemble() -> UIViewController {
        let view = ConsumerProfileViewController()
        let router = ConsumerProfileRouter()
        let presenter = ConsumerProfilePresenter()
        let interactor = ConsumerProfileInteractor()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        router.view = view

        return view
    }

}
