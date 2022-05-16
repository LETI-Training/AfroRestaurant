import Foundation

class ConsumerDishViewPresenter {
    weak var view: ConsumerDishViewViewInput?
    var interactor: ConsumerDishViewInteractorInput?
    var router: ConsumerDishViewRouter?
    
    var dishModel: DishModel
    
    private var likesCount = 0 {
        didSet {
            DispatchQueue.main.async {
                self.view?.updateLikes(likesCount: self.likesCount)
            }
        }
    }
    
    private var ratings = 0.0 {
        didSet {
            DispatchQueue.main.async {
                self.view?.updateRatings(rating: self.ratings)
            }
        }
    }

    init(dishModel: DishModel) {
        self.dishModel = dishModel
    }
    
    private func updateView() {
        view?.updateUI(
            model: dishModel,
            viewModel: .init(
                isLiked: interactor?.isDishInFavorites(dishModel: dishModel) ?? false,
                isInCart: interactor?.isDishInCart(dishModel: dishModel) ?? false
            )
        )
    }
}

extension ConsumerDishViewPresenter: ConsumerDishViewPresenterProtocol {
    func viewWillAppear() {
        interactor?.loadLikesCount(dishname: dishModel.dishName, in: dishModel.categoryName)
        interactor?.loadRatingsCount(dishName: dishModel.dishName, in: dishModel.categoryName)
        
        interactor?.loadDish(dishName: dishModel.dishName, for: dishModel.categoryName, completion: { [weak self] dishModel in
            guard let dishModel = dishModel else { return }
            self?.dishModel = dishModel
            self?.updateView()
        })
    }
    
    func cartButtonTapped() {
        let isInCart = interactor?.isDishInCart(dishModel: dishModel) == true
        
        if isInCart {
            interactor?.removeDishFromCart(
                dishModel: .init(
                    dishName: dishModel.dishName,
                    categoryName: dishModel.categoryName
                ), completion: { [weak self] in
                    self?.updateView()
                })
        } else {
            interactor?.addDishToCart(
                dishModel: .init(
                    minimalModel: .init(dishName: dishModel.dishName, categoryName: dishModel.categoryName),
                    quantity: 1,
                    date: nil
                )
            )
            updateView()
        }
    }
    
    func buyMealPressed() {
        let isInCart = interactor?.isDishInCart(dishModel: dishModel) == true
        
        if !isInCart {
            interactor?.addDishToCart(
                dishModel: .init(
                    minimalModel: .init(dishName: dishModel.dishName, categoryName: dishModel.categoryName),
                    quantity: 1,
                    date: nil
                )
            )
            updateView()
        }
        router?.moveToCartTab()
    }
    
    func addToFavoritesPressed() {
        let isInFavorite = interactor?.isDishInFavorites(dishModel: dishModel) == true
        
        if isInFavorite {
            likesCount -= 1
            interactor?.removeDishFromFavorite(
                dishModel: .init(
                    dishName: dishModel.dishName,
                    categoryName: dishModel.categoryName
                ), completion: { [weak self] in
                    self?.updateView()
                })
        } else {
            likesCount += 1
            interactor?.addDishToFavorite(dishModel: .init(dishName: dishModel.dishName, categoryName: dishModel.categoryName))
            updateView()
        }
    }
    
    func viewDidLoad() {
        interactor?.likesListener = { [weak self] likes, dish, category  in
            guard
                dish == self?.dishModel.dishName,
                category == self?.dishModel.categoryName else { return }
            self?.likesCount = likes
        }
        
        interactor?.ratingsListener = { [weak self] ratings, dish, category  in
            guard
                dish == self?.dishModel.dishName,
                category == self?.dishModel.categoryName else { return }
            self?.ratings = ratings
        }
        updateView()
        interactor?.loadLikesCount(dishname: dishModel.dishName, in: dishModel.categoryName)
        interactor?.loadRatingsCount(dishName: dishModel.dishName, in: dishModel.categoryName)
    }
    
    func didTapNewRateView() {
        view?.presentAlertWithTextField(
            title: "Rate Dish from 1-5",
            actionCancel: .init(actionText: "Cancel", actionHandler: {}),
            actionComplete: .init(actionText: "Rate", actionHandler: {}),
            placeHolder: "Rate from 1-5",
            completion: { [weak self] rating in
                guard
                    let self = self,
                    let rating = Int(rating),
                    rating <= 5 && rating > 0
                else {
                    self?.view?.presentAlert(
                        title: "Error",
                        message: "Rating must be an integer \n value from 1 - 5",
                        action: .init(actionText: "Okay", actionHandler: {}))
                    return
                }
                
                self.interactor?.rateDish(
                    rating: Double(rating),
                    dishname: self.dishModel.dishName,
                    categoryName: self.dishModel.categoryName
                )
                
                DispatchQueue.global().asyncAfter(deadline: .now() + 0.3) {
                    self.interactor?.loadRatingsCount(
                        dishName: self.dishModel.dishName,
                        in: self.dishModel.categoryName
                    )
                }
            }
        )
    }
}
