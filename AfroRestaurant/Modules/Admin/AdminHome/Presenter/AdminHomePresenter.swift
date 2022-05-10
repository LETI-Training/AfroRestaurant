import Foundation

class AdminHomePresenter {
    weak var view: AdminHomeViewInput?
    var interactor: AdminHomeInteractorInput?
    var router: AdminHomeRouter?
    
    var orders: [AdminAnalyticsDataBaseService.OrderModel] = []

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
        
        interactor?.ordersListener = { [weak self] orders in
            self?.orders = orders
            self?.generateOrderData()
        }
    }
    
    private func generateOrderData() {
        
        let newOrdersCount = orders.filter({ $0.type == .created }).count
        let cancelledOrderCount = orders.filter({ $0.type == .cancelled }).count
        
        let profitsToday = orders
            .filter({ $0.type == .delivered && Calendar.current.isDateInToday($0.date) })
            .reduce(0.0) { partialResult, orderModel in
                partialResult + orderModel.dishModels.reduce(0.0) { partialResult, dishModel in
                    return partialResult + (dishModel.price * Double(dishModel.quantity))
                }
            }
        
        view?.updateUI(
            dailyProfits: "RUB \(profitsToday)",
            newOrders: "\(newOrdersCount)",
            cancelledOrders: "\(cancelledOrderCount)"
        )
    }
}

extension AdminHomePresenter: AdminHomePresenterProtocol {
    func viewWillAppear() {
        viewDidLoad()
    }
    
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
        interactor?.loadOrders()
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
