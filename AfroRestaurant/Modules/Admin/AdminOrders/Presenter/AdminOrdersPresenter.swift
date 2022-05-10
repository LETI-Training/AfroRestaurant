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
        let viewModels: [AdminOrdersViewController.ViewModel] = orders.compactMap { orderModel in
           let sectionModel =  AdminOrdersHeaderView.ViewModel(
                dateString: formatter.string(from: orderModel.date),
                orderNumber: orderModel.orderNumber,
                userDetails: orderModel.userDetails) { [weak self, orderModel] viewModel in
                    self?.interactor?.updateOrderStatus(status: .delivered, orderNumber: orderModel.orderNumber)
                } deleteButtonTapped: { [weak self, orderModel] viewModel in
                    self?.interactor?.updateOrderStatus(status: .cancelled, orderNumber: orderModel.orderNumber)
                }
            
            let cellModels: [AdminOrdersTableViewCell.ViewModel] = orderModel.dishModels.compactMap { dishModel in
                return .init(
                    quantity: dishModel.quantity,
                    dishName: dishModel.dishName,
                    price: dishModel.price,
                    orderType: orderModel.type
                )
            }
            return .init(
                sectionModel: sectionModel,
                cellModels: cellModels
            )
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

