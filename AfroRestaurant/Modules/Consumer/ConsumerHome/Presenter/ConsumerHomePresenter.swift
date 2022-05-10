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
            DispatchQueue.main.async {
                self?.generateData(for: categoryModels)
            }
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
        self.view?.updateView(viewModels: viewModels)
    }
    
    private func getCellModels(from categoryModel: CategoryModel) -> [DishesCollectionViewCell.ViewModel] {
        return categoryModel.dishes.compactMap { model in
            let data = Data(base64Encoded: model.imageString) ?? Data()
            let dishModel = model
            let cartModel = interactor?.isDishInCart(dishModel: model)
            let isInCart = cartModel == true
            let isLiked = interactor?.isDishInFavorites(dishModel: model) ?? false
            return DishesCollectionViewCell.ViewModel(
                type: .withCart(isAdded: isInCart),
                buttonType: .like(isLiked: isLiked),
                dishName: model.dishName,
                rating: model.rating ?? 0.0,
                calories: model.calories,
                price: model.price,
                image: UIImage(data: data)) { [weak self, dishModel] viewModel in
                    if isLiked {
                        self?.interactor?.removeDishFromFavorite(dishModel: .init(dishName: dishModel.dishName, categoryName: categoryModel.categoryName), completion: {
                            self?.loadData()
                        })
                    } else {
                        self?.interactor?.addDishToFavorite(dishModel: .init(dishName: dishModel.dishName, categoryName: categoryModel.categoryName))
                        self?.loadData()
                    }
                } cartButtonTapped: { [weak self] _ in
                    isInCart
                    ? self?.interactor?
                        .removeDishFromCart(
                            dishModel: .init(dishName: dishModel.dishName, categoryName: categoryModel.categoryName),
                            completion: {
                                self?.loadData()
                            })
                    : self?.interactor?
                        .addDishToCart(dishModel: .init(minimalModel: .init(dishName: dishModel.dishName, categoryName: categoryModel.categoryName), quantity: 1, date: nil))
                    self?.loadData()
                } buyNowButtonTapped: { [weak self]  _ in
                    let isInCart = self?.interactor?.isDishInCart(dishModel: dishModel) == true
                    
                    if !isInCart {
                        self?.interactor?.addDishToCart(
                            dishModel: .init(
                                minimalModel: .init(dishName: dishModel.dishName, categoryName: dishModel.categoryName),
                                quantity: 1,
                                date: nil
                            )
                        )
                        self?.loadData()
                    }
                    self?.router?.moveToCartTab()
                }
        }
    }
}

extension ConsumerHomePresenter: ConsumerHomePresenterProtocol {
    func dishTapped(at indexPath: IndexPath) {
        router?.routeToDishe(
            dish: models[indexPath.section].dishes[indexPath.row],
            categoryName: models[indexPath.section].categoryName
        )
    }
    
    func viewWillAppear() {
        loadData()
    }
    
    func viewDidLoad() {
        loadData()
    }
}
