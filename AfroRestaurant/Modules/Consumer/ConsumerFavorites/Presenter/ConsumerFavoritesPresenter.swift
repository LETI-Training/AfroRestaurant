import Foundation
import UIKit

class ConsumerFavoritesPresenter {
    weak var view: ConsumerFavoritesViewInput?
    var interactor: ConsumerFavoritesInteractorInput?
    var router: ConsumerFavoritesRouter?
    
    var models = [DishModel]()

    init() {}
    
    private func loadData() {
        interactor?.loadFavorites(completion: { [weak self] dishModels in
            DispatchQueue.main.async {
                self?.generateData(for: dishModels)
            }
        })
    }
    
    private func generateData(for dishModels: [DishModel]?) {
        guard let dishModels = dishModels else {
            return
        }
        self.models = dishModels
        
        let viewModels: [DishesCollectionViewCell.ViewModel] = dishModels.compactMap { model in
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
                        self?.interactor?.removeDishFromFavorite(dishModel: .init(dishName: dishModel.dishName, categoryName: dishModel.categoryName), completion: {
                            self?.loadData()
                        })
                    } else {
                        self?.interactor?.addDishToFavorite(dishModel: .init(dishName: dishModel.dishName, categoryName: dishModel.categoryName))
                        self?.loadData()
                    }
                } cartButtonTapped: { [weak self] _ in
                    isInCart
                    ? self?.interactor?
                        .removeDishFromCart(
                            dishModel: .init(dishName: dishModel.dishName, categoryName: dishModel.categoryName),
                            completion: {
                                self?.loadData()
                            })
                    : self?.interactor?
                        .addDishToCart(dishModel: .init(minimalModel: .init(dishName: dishModel.dishName, categoryName: dishModel.categoryName), quantity: 1, date: nil))
                    self?.loadData()
                } buyNowButtonTapped: { [weak self]  _ in
                    self?.router?.moveToCartTab()
                }
        }
        self.view?.updateView(viewModels: viewModels)
    }
}

extension ConsumerFavoritesPresenter: ConsumerFavoritesPresenterProtocol {
    func viewWillAppear() {
        loadData()
    }
    
    func dishTapped(at index: Int) {
        router?.routeToDishe(
            dish: models[index],
            categoryName: models[index].categoryName
        )
    }
    
    func viewDidLoad() {
        loadData()
    }
}
