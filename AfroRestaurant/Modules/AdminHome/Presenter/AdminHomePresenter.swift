class AdminHomePresenter {
    weak var view: AdminHomeViewInput?
    var interactor: AdminHomeInteractorInput?
    var router: AdminHomeRouter?

    init() {}
}

extension AdminHomePresenter: AdminHomePresenterProtocol {

    func viewDidLoad() {
    }
}
