class ConsumerHomePresenter {
    weak var view: ConsumerHomeViewInput?
    var interactor: ConsumerHomeInteractorInput?
    var router: ConsumerHomeRouter?

    init() {}
}

extension ConsumerHomePresenter: ConsumerHomePresenterProtocol {

    func viewDidLoad() {
    }
}
