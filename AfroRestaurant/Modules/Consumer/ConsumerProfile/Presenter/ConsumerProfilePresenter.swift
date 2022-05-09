class ConsumerProfilePresenter {
    weak var view: ConsumerProfileViewInput?
    var interactor: ConsumerProfileInteractorInput?
    var router: ConsumerProfileRouter?

    init() {}
}

extension ConsumerProfilePresenter: ConsumerProfilePresenterProtocol {

    func viewDidLoad() {
    }
}
