import Foundation

extension ConsumerOrdersPresenter {
    enum OrderFilterType: Int, CaseIterable, Equatable {
        case all = 0
        case new
        case delivered
        case cancelled
        
        var name: String {
            switch self {
            case .all:
                return "All"
            case .new:
                return "New"
            case .cancelled:
                return "Cancelled"
            case .delivered:
                return "Delivered"
            }
        }
    }
}

class ConsumerOrdersPresenter {
    weak var view: ConsumerOrdersViewInput?
    var interactor: ConsumerOrdersInteractorInput?
    var router: ConsumerOrdersRouter?
    var filterType: OrderFilterType = .all
    
    var models = [AdminAnalyticsDataBaseService.OrderModel]()
    
    init() {}
    
    private func loadData() {
        let orderStatus: AdminAnalyticsDataBaseService.OrderStatus?
        
        switch filterType {
        case .all:
            orderStatus = nil
        case .new:
            orderStatus = .created
        case .cancelled:
            orderStatus = .cancelled
        case .delivered:
            orderStatus = .delivered
        }
        
        var orders = models.sorted(by: { $1.date < $0.date })
        
        if let orderStatus = orderStatus {
            orders = orders.filter({ $0.type == orderStatus })
        }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        var viewModels: [ConsumerOrdersViewController.ViewModel] = []
        orders.forEach { orderModel in
           let sectionModel =  AdminOrdersHeaderView.ViewModel(
                dateString: formatter.string(from: orderModel.date),
                orderNumber: orderModel.orderNumber,
                orderStatus: orderModel.type,
                userType: .consumer,
                userDetails: orderModel.userDetails) { [weak self, orderModel] viewModel in
                    self?.interactor?.updateOrderStatus(status: .cancelled, orderNumber: orderModel.orderNumber)
                } deliverButtonTapped: { [weak self, orderModel] viewModel in
                    self?.interactor?.updateOrderStatus(status: .delivered, orderNumber: orderModel.orderNumber)
                }
            
            viewModels.append(.init(type: .header(sectionModel)))
            
            orderModel.dishModels.forEach { dishModel in
                let cellModel = AdminOrdersTableViewCell.ViewModel(
                    quantity: dishModel.quantity,
                    dishName: dishModel.dishName,
                    price: dishModel.price * Double(dishModel.quantity),
                    orderType: orderModel.type
                )
                viewModels.append(.init(type: .dishes(cellModel)))
            }
            
        }
        view?.updateItems(viewModels: viewModels)
    }
    
}

extension ConsumerOrdersPresenter: ConsumerOrdersPresenterProtocol {

    func segmentedControllerTapped(newIndex: Int) {
        guard let filterType = OrderFilterType(rawValue: newIndex) else { return }
        
        self.filterType = filterType
        loadData()
    }
    
    func viewWillAppear() {
        interactor?.loadOrders()
    }
    
    func viewDidLoad() {
        view?.changeSelectedIndex(index: filterType.rawValue)
        interactor?.loadOrders()
        interactor?.listener = { [weak self] models in
            self?.models = models
            self?.loadData()
        }
    }
}
