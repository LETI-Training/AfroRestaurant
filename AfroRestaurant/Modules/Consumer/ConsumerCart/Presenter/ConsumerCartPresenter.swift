class ConsumerCartPresenter {
    weak var view: ConsumerCartViewInput?
    var interactor: ConsumerCartInteractorInput?
    var router: ConsumerCartRouter?

    init() {}
}

extension ConsumerCartPresenter: ConsumerCartPresenterProtocol {

    func viewDidLoad() {
    }
}
