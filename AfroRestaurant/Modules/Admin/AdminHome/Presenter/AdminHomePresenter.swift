import Foundation

class AdminHomePresenter {
    weak var view: AdminHomeViewInput?
    var interactor: AdminHomeInteractorInput?
    var router: AdminHomeRouter?
    
    var orders: [AdminAnalyticsDataBaseService.OrderModel] = []
    var updates = [UpdateModel]()

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
        
        interactor?.updatesListener = { [weak self] updates in
            guard let self = self else { return }
            self.updates = updates
            self.view?.updateItems(viewModels: self.getTableViewModels())
        }
        
        interactor?.restaurantRatingListener = { [weak self] ratings in
            guard let self = self else { return }
            self.view?.updateRatings(ratings: ratings)
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
        interactor?.loadAllUpdates()
        interactor?.loadRestaurantRating()
        view?.updateItems(viewModels: getTableViewModels())
    }
}

extension AdminHomePresenter {
    private func getTableViewModels() -> [AdminUpdatesTableViewCell.ViewModel] {
        let updates = updates.sorted(by: { $1.date < $0.date })
        return updates.compactMap({
            let type: AdminUpdatesTableViewCell.ImageType
            
            switch $0.type {
            case .rating:
                type = .rating(rating: Int($0.rating))
            case .likes:
                type = .favorite
            }
            
            return AdminUpdatesTableViewCell.ViewModel.init(name: $0.userName, dish: $0.dishname, type: type)
        })
        
    }
}
