import Foundation

class AdminProfitsPresenter {
    weak var view: AdminProfitsViewInput?
    var interactor: AdminProfitsInteractorInput?
    var router: AdminProfitsRouter?
    var orders: [AdminAnalyticsDataBaseService.OrderModel] = []

    init() {}
}

extension AdminProfitsPresenter: AdminProfitsPresenterProtocol {
    func profitsTapped() {
        router?.routeToOrders(filterType: .all)
    }

    func viewDidLoad() {
        interactor?.ordersListener = { [weak self] orders in
            self?.orders = orders
            self?.generateOrderData()
        }
        interactor?.loadOrders()
        generateOrderData()
    }
    
    private func generateOrderData() {
        let sortedOrders = orders
            .sorted(by: { $1.date < $0.date })
            .filter({ $0.type == .delivered })
        
        let totalProfits = sortedOrders
            .reduce(0.0) { partialResult, orderModel in
                partialResult + orderModel.dishModels.reduce(0.0) { partialResult, dishModel in
                    return partialResult + (dishModel.price * Double(dishModel.quantity))
                }
            }
        view?.updateUI(totalProfits:  "RUB \(totalProfits)")
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        let viewModels: [AdminProfitsTableViewCell.ViewModel] = sortedOrders.compactMap {
            let orderProfit = $0.dishModels
                .reduce(0.0) { partialResult, dishModel in
                    return partialResult + (dishModel.price * Double(dishModel.quantity))
                }
            
            return .init(orderNumber: $0.orderNumber, date: formatter.string(from: $0.date), price: orderProfit)
        }
        view?.updateItems(viewModels: viewModels)
    }
}

