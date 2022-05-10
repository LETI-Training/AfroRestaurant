class AdminHomePresenter {
    weak var view: AdminHomeViewInput?
    var interactor: AdminHomeInteractorInput?
    var router: AdminHomeRouter?

    init() {}
    
    private func setupErrorListner() {
        interactor?.authErrorListner = { [weak self] errorText in
            self?.view?.presentAlert(
                title: "Error",
                message: errorText,
                action: .init(actionText: "Ok", actionHandler: {}),
                action2: nil
            )
        }
    }
}

extension AdminHomePresenter: AdminHomePresenterProtocol {
    func didTapCancelledView() {
        router?.routeToOrders(filterType: .cancelled)
    }
    
    func didTapNewOrdersView() {
        router?.routeToOrders(filterType: .new)
    }
    
    func didTapProfileImage() {
        view?.presentAlert(
            title: "Painful to see you go 😔",
            message: "Are you sure you want to log out?",
            action: .init(actionText: "No", actionHandler: {}),
            action2: .init(actionText: "Yes", actionHandler: { [weak self] in
                self?.interactor?.performLogout()
            })
        )
    }
    
    func viewDidLoad() {
        setupErrorListner()
        view?.updateUI(
            dailyProfits: "RUB 1,365",
            newOrders: "\(Int.random(in: 0...50))",
            cancelledOrders: "\(Int.random(in: 0...50))"
        )
        view?.updateItems(viewModels: getTableViewModels())
    }
}

extension AdminHomePresenter {
    private func getTableViewModels() -> [AdminUpdatesTableViewCell.ViewModel] {
        [
            .init(name: "Michael", dish: "Spaghetti", type: .favorite),
            .init(name: "Jane", dish: "Coconut Rice", type: .favorite),
            .init(name: "Samuel", dish: "Egusi", type: .favorite),
            .init(name: "Jenny", dish: "Rice", type: .rating),
            .init(name: "Samuel", dish: "Egusi", type: .favorite),
            .init(name: "Jamila", dish: "Beans", type: .rating),
            .init(name: "Michael", dish: "Spaghetti", type: .favorite),
            .init(name: "Jane", dish: "Coconut Rice", type: .favorite),
            .init(name: "Samuel", dish: "Egusi", type: .favorite),
            .init(name: "Jenny", dish: "Rice", type: .rating),
            .init(name: "Samuel", dish: "Egusi", type: .favorite),
            .init(name: "Jamila", dish: "Beans", type: .rating),
            .init(name: "Michael", dish: "Spaghetti", type: .favorite),
            .init(name: "Jane", dish: "Coconut Rice", type: .favorite),
            .init(name: "Samuel", dish: "Egusi", type: .favorite),
            .init(name: "Jenny", dish: "Rice", type: .rating),
            .init(name: "Samuel", dish: "Egusi", type: .favorite),
            .init(name: "Jamila", dish: "Beans", type: .rating),
            .init(name: "Michael", dish: "Spaghetti", type: .favorite),
            .init(name: "Jane", dish: "Coconut Rice", type: .favorite),
            .init(name: "Samuel", dish: "Egusi", type: .favorite),
            .init(name: "Jenny", dish: "Rice", type: .rating),
            .init(name: "Samuel", dish: "Egusi", type: .favorite),
            .init(name: "Jamila", dish: "Beans", type: .rating),
            .init(name: "Michael", dish: "Spaghetti", type: .favorite),
            .init(name: "Jane", dish: "Coconut Rice", type: .favorite),
            .init(name: "Samuel", dish: "Egusi", type: .favorite),
            .init(name: "Jenny", dish: "Rice", type: .rating),
            .init(name: "Samuel", dish: "Egusi", type: .favorite),
            .init(name: "Jamila", dish: "Beans", type: .rating),
            .init(name: "Michael", dish: "Spaghetti", type: .favorite),
            .init(name: "Jane", dish: "Coconut Rice", type: .favorite),
            .init(name: "Samuel", dish: "Egusi", type: .favorite),
            .init(name: "Jenny", dish: "Rice", type: .rating),
            .init(name: "Samuel", dish: "Egusi", type: .favorite),
            .init(name: "Jamila", dish: "Beans", type: .rating)
        ]
        
    }
}
