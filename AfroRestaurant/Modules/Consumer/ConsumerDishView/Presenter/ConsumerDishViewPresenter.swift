class ConsumerDishViewPresenter {
    weak var view: ConsumerDishViewViewInput?
    var interactor: ConsumerDishViewInteractorInput?
    var router: ConsumerDishViewRouter?
    
    var dishModel: DishModel

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
                    quantity: 1
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
                    quantity: 1
                )
            )
            updateView()
        }
        router?.moveToCartTab()
    }
    
    func addToFavoritesPressed() {
        let isInFavorite = interactor?.isDishInFavorites(dishModel: dishModel) == true
        
        if isInFavorite {
            interactor?.removeDishFromFavorite(
                dishModel: .init(
                    dishName: dishModel.dishName,
                    categoryName: dishModel.categoryName
                ), completion: { [weak self] in
                    self?.updateView()
                })
        } else {
            interactor?.addDishToFavorite(dishModel: .init(dishName: dishModel.dishName, categoryName: dishModel.categoryName))
            updateView()
        }
    }
    
    func viewDidLoad() {
        updateView()
    }
}
