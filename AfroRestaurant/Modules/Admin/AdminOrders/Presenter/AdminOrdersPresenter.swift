import Foundation

extension AdminOrdersPresenter {
    enum OrderFilterType: Int, CaseIterable {
        case all = 0
        case new
        case cancelled
        
        var name: String {
            switch self {
            case .all:
                return "All"
            case .new:
                return "New"
            case .cancelled:
                return "Cancelled"
            }
        }
    }
}

class AdminOrdersPresenter {
    weak var view: AdminOrdersViewInput?
    var interactor: AdminOrdersInteractorInput?
    var router: AdminOrdersRouter?
    
    var models = [AdminAnalyticsDataBaseService.OrderModel]()
    
    var filterType: OrderFilterType
    
    init(filterType: OrderFilterType) {
        self.filterType = filterType
    }
    
    private func loadData() {
        let orders = models.sorted(by: { $1.date < $0.date })
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        var viewModels: [AdminOrdersViewController.ViewModel] = []
        orders.forEach { orderModel in
           let sectionModel =  AdminOrdersHeaderView.ViewModel(
                dateString: formatter.string(from: orderModel.date),
                orderNumber: orderModel.orderNumber,
                orderStatus: orderModel.type,
                userType: .admin,
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
                    price: dishModel.price,
                    orderType: orderModel.type
                )
                viewModels.append(.init(type: .dishes(cellModel)))
            }
            
        }
        view?.updateItems(viewModels: viewModels)
    }
    
}

extension AdminOrdersPresenter: AdminOrdersPresenterProtocol {
    func segmentedControllerTapped(newIndex: Int) {
        
    }
    
    func viewWillAppear() {
        interactor?.loadOrders()
    }
    
    func viewDidLoad() {
        
        interactor?.loadOrders()
        interactor?.listener = { [weak self] models in
            self?.models = models
            self?.loadData()
            self?.interactor?.loadOrders()
        }
    }
}

