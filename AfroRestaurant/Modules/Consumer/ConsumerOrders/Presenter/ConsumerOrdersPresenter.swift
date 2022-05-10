class ConsumerOrdersPresenter {
    weak var view: ConsumerOrdersViewInput?
    var interactor: ConsumerOrdersInteractorInput?
    var router: ConsumerOrdersRouter?

    init() {}
}

extension ConsumerOrdersPresenter: ConsumerOrdersPresenterProtocol {

    func viewDidLoad() {
    }
}
