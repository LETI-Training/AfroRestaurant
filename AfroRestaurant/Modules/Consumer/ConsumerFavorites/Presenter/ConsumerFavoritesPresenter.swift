class ConsumerFavoritesPresenter {
    weak var view: ConsumerFavoritesViewInput?
    var interactor: ConsumerFavoritesInteractorInput?
    var router: ConsumerFavoritesRouter?

    init() {}
}

extension ConsumerFavoritesPresenter: ConsumerFavoritesPresenterProtocol {

    func viewDidLoad() {
    }
}
