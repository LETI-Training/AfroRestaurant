import Foundation
import UIKit

class ConsumerHomePresenter {
    weak var view: ConsumerHomeViewInput?
    var interactor: ConsumerHomeInteractorInput?
    var router: ConsumerHomeRouter?
    
    var models = [CategoryModel]()
    
    init() {}
    
    private func loadData() {
        interactor?.loadCategories(completion: { [weak self] categoryModels in
            self?.generateData(for: categoryModels)
        })
    }
    
    private func generateData(for categoryModels: [CategoryModel]?) {
        guard let categoryModels = categoryModels else {
            return
        }
        self.models = categoryModels
        
        let viewModels = categoryModels.compactMap { categoryModel -> ConsumerHomeViewController.ViewModel in
            return .init(
                categoryName: categoryModel.categoryName,
                cellModels: getCellModels(from: categoryModel)
            )
        }
        DispatchQueue.main.async {
            self.view?.updateView(viewModels: viewModels)
        }
    }
    
    private func getCellModels(from categoryModel: CategoryModel) -> [DishesCollectionViewCell.ViewModel] {
        return categoryModel.dishes.compactMap { model in
            let data = Data(base64Encoded: model.imageString) ?? Data()
            let dishModel = model
            let cartModel = interactor?.isDishInCart(dishModel: model)
            let isInCart = cartModel != nil
            return DishesCollectionViewCell.ViewModel(
                type: .withCart(isAdded: isInCart),
                buttonType: .like(isLiked: interactor?.isDishInFavorites(dishModel: model) ?? false),
                dishName: model.dishName,
                rating: model.rating ?? 0.0,
                calories: model.calories,
                price: model.price,
                image: UIImage(data: data)) { [weak self] viewModel in
                    self?.interactor?.addDishToFavorite(dishModel: dishModel)
                } cartButtonTapped: { [weak self] _ in
                    isInCart
                    ? self?.interactor?.removeDishFromCart(dishModel: dishModel, completion: {
                        self?.loadData()
                    })
                    : self?.interactor?.addDishToCart(dishModel: dishModel, quantity: 1)
                    self?.loadData()
                } buyNowButtonTapped: { [weak self] _ in
                    self?.interactor?.addDishToCart(dishModel: dishModel, quantity: 0)
                }
        }
    }
}

extension ConsumerHomePresenter: ConsumerHomePresenterProtocol {
    func dishTapped(at indexPath: IndexPath) {
        
    }
    
    func viewWillAppear() {
        loadData()
    }
    
    func viewDidLoad() {
        loadData()
    }
}
