import UIKit

class ConsumerCartPresenter {
    weak var view: ConsumerCartViewInput?
    var interactor: ConsumerCartInteractorInput?
    var router: ConsumerCartRouter?
    
    private var cartModels: [CartModel] = []

    init() {}
    
    private func loadData() {
        interactor?.loadCarts(completion: { [weak self] cartModels in
            self?.cartModels = cartModels ?? []
            self?.generateViewModels()
        })
    }
    
    private func generateViewModels() {
        
        let carts = cartModels.sorted(by: { $1.date < $0.date })
        
        var viewModels: [ConsumerCartViewController.ViewModel] = carts.compactMap { model in
            let data = Data(base64Encoded: model.dishModel.imageString) ?? Data()
            let viewModel = CartTableViewCell.ViewModel(
                image: UIImage(data: data),
                name: model.dishModel.dishName,
                calories: model.dishModel.calories,
                amount: model.dishModel.price * Double(model.quantity),
                quantity: model.quantity) { [weak self, model] count, _ in
                    if count <= 0 {
                        self?.interactor?.removeDishFromCart(
                            dishModel: .init(dishName: model.dishModel.dishName, categoryName: model.dishModel.categoryName),
                            completion: {
                                self?.loadData()
                            })
                    } else {
                        let minimalData = ConsumerDataBaseService.ConsumerDishMinimalModel(
                            dishName: model.dishModel.dishName,
                            categoryName: model.dishModel.categoryName
                        )
                        self?.interactor?.addDishToCart(dishModel: .init(minimalModel: minimalData, quantity: count, date: nil))
                        self?.loadData()
                    }
                } deleteButtonTapped: { [weak self, model] viewModel in
                    self?.interactor?.removeDishFromCart(
                        dishModel: .init(dishName: model.dishModel.dishName, categoryName: model.dishModel.categoryName),
                        completion: {
                            self?.loadData()
                        })
                }
            
            return .init(type: .cart(viewModel))
        }
        
        let totalAmount = cartModels.reduce(0.0) { partialResult, model in
            partialResult + (Double(model.quantity) * model.dishModel.price)
        }
        
        if !cartModels.isEmpty {
            let amountViewModel = CartPriceLabelCell.ViewModel(totalAmount: totalAmount)
            viewModels.append(.init(type: .amount(amountViewModel)))
        }
        
        view?.updateItems(viewModels: viewModels, cartCount: cartModels.count)
    }
}

extension ConsumerCartPresenter: ConsumerCartPresenterProtocol {
    func checkoutButtonTapped() {
        
    }
    
    func viewWillAppear() {
        loadData()
    }
    

    func viewDidLoad() {
        loadData()
    }
}
