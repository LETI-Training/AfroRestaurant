class ConsumerMapPresenter {
    weak var view: ConsumerMapViewInput?
    var interactor: ConsumerMapInteractorInput?
    var router: ConsumerMapRouter?

    init() {}
}

extension ConsumerMapPresenter: ConsumerMapPresenterProtocol {

    func viewDidLoad() {
    }
}
