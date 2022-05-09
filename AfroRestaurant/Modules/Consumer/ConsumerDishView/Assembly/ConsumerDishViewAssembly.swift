import UIKit

class ConsumerDishViewAssembly {

    static func assemble(dishModel: DishModel, categoryName: String) -> UIViewController {
        let view = ConsumerDishViewViewController()
        let router = ConsumerDishViewRouter()
        let presenter = ConsumerDishViewPresenter()
        let interactor = ConsumerDishViewInteractor()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        router.view = view

        return view
    }

}
