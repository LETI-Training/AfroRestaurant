import UIKit

class ConsumerDishViewAssembly {

    static func assemble(dishModel: DishModel) -> UIViewController {
        let view = ConsumerDishViewViewController()
        let router = ConsumerDishViewRouter()
        let presenter = ConsumerDishViewPresenter(dishModel: dishModel)
        let interactor = ConsumerDishViewInteractor(
            consumerDataBase: ServiceLocator.shared.getService()!,
            ordersService: ServiceLocator.shared.getService()!
        )

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        router.view = view

        return view
    }

}
