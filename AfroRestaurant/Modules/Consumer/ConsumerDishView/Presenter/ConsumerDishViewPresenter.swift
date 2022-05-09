class ConsumerDishViewPresenter {
    weak var view: ConsumerDishViewViewInput?
    var interactor: ConsumerDishViewInteractorInput?
    var router: ConsumerDishViewRouter?

    init() {}
}

extension ConsumerDishViewPresenter: ConsumerDishViewPresenterProtocol {

    func viewDidLoad() {
    }
}
