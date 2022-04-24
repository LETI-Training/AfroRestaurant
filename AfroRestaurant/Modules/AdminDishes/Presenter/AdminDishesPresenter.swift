class AdminDishesPresenter {
    weak var view: AdminDishesViewInput?
    var interactor: AdminDishesInteractorInput?
    var router: AdminDishesRouter?
    
    let category: AdminCreateCategoryModel

    init(category: AdminCreateCategoryModel) {
        self.category = category
    }
}

extension AdminDishesPresenter: AdminDishesPresenterProtocol {
    func createNewDishTapped() {
        router?.presentNewDish(output: self, category: category)
    }
    
    func viewDidLoad() {
        view?.updateTitle(title: category.categoryName)
        view?.updateItems(description: "jefjejfjfejfejfje", viewModels: [
            .init(type: .delete, dishName: "ejdjejejefj", rating: 74745, calories: 8484, price: 84848, image: .launchScreen, buttonTapHandler: { _ in
                
            }),
            .init(type: .delete, dishName: "ejdjejejefj", rating: 74745, calories: 8484, price: 84848, image: .launchScreen, buttonTapHandler: { _ in
                
            }),
            .init(type: .delete, dishName: "ejdjejejefj", rating: 74745, calories: 8484, price: 84848, image: .launchScreen, buttonTapHandler: { _ in
                
            }),
            .init(type: .delete, dishName: "ejdjejejefj", rating: 74745, calories: 8484, price: 84848, image: .launchScreen, buttonTapHandler: { _ in
                
            }),.init(type: .delete, dishName: "ejdjejejefj", rating: 74745, calories: 8484, price: 84848, image: .launchScreen, buttonTapHandler: { _ in
                
            }),.init(type: .delete, dishName: "ejdjejejefj", rating: 74745, calories: 8484, price: 84848, image: .launchScreen, buttonTapHandler: { _ in
                
            }),
            .init(type: .delete, dishName: "ejdjejejefj", rating: 74745, calories: 8484, price: 84848, image: .launchScreen, buttonTapHandler: { _ in
                
            }),
            .init(type: .delete, dishName: "ejdjejejefj", rating: 74745, calories: 8484, price: 84848, image: .afroHeader, buttonTapHandler: { _ in
                
            }),
            .init(type: .delete, dishName: "ejdjejejefj", rating: 74745, calories: 8484, price: 84848, image: .afroHeader, buttonTapHandler: { _ in
                
            }),
            .init(type: .delete, dishName: "ejdjejejefj", rating: 74745, calories: 8484, price: 84848, image: .afroHeader, buttonTapHandler: { _ in
                
            }),.init(type: .delete, dishName: "ejdjejejefj", rating: 74745, calories: 8484, price: 84848, image: .afroHeader, buttonTapHandler: { _ in
                
            }),
            .init(type: .delete, dishName: "ejdjejejefj", rating: 74745, calories: 8484, price: 84848, image: .afroHeader, buttonTapHandler: { _ in
                
            }),
            .init(type: .delete, dishName: "ejdjejejefj", rating: 74745, calories: 8484, price: 84848, image: .afroHeader, buttonTapHandler: { _ in
                
            }),
            .init(type: .delete, dishName: "ejdjejejefj", rating: 74745, calories: 8484, price: 84848, image: .afroHeader, buttonTapHandler: { _ in
                
            }),
            .init(type: .delete, dishName: "ejdjejejefj", rating: 74745, calories: 8484, price: 84848, image: .afroHeader, buttonTapHandler: { _ in
                
            }),
            .init(type: .delete, dishName: "ejdjejejefj", rating: 74745, calories: 8484, price: 84848, image: .afroHeader, buttonTapHandler: { _ in
                
            }),
            .init(type: .delete, dishName: "ejdjejejefj", rating: 74745, calories: 8484, price: 84848, image: .afroHeader, buttonTapHandler: { _ in
                
            }),
            .init(type: .delete, dishName: "ejdjejejefj", rating: 74745, calories: 8484, price: 84848, image: .afroHeader, buttonTapHandler: { _ in
                
            }),
            .init(type: .delete, dishName: "ejdjejejefj", rating: 74745, calories: 8484, price: 84848, image: .afroHeader, buttonTapHandler: { _ in
                
            }),
            .init(type: .delete, dishName: "ejdjejejefj", rating: 74745, calories: 8484, price: 84848, image: .afroHeader, buttonTapHandler: { _ in
                
            }),
            .init(type: .delete, dishName: "ejdjejejefj", rating: 74745, calories: 8484, price: 84848, image: .afroHeader, buttonTapHandler: { _ in
                
            }),
            .init(type: .delete, dishName: "ejdjejejefj", rating: 74745, calories: 8484, price: 84848, image: .afroHeader, buttonTapHandler: { _ in
                
            }),
            .init(type: .delete, dishName: "ejdjejejefj", rating: 74745, calories: 8484, price: 84848, image: .afroHeader, buttonTapHandler: { _ in
                
            }),
            .init(type: .delete, dishName: "ejdjejejefj", rating: 74745, calories: 8484, price: 84848, image: .afroHeader, buttonTapHandler: { _ in
                
            }),
            .init(type: .delete, dishName: "ejdjejejefj", rating: 74745, calories: 8484, price: 84848, image: .afroHeader, buttonTapHandler: { _ in
                
            }),
            .init(type: .delete, dishName: "ejdjejejefj", rating: 74745, calories: 8484, price: 84848, image: .afroHeader, buttonTapHandler: { _ in
                
            }),
            .init(type: .delete, dishName: "ejdjejejefj", rating: 74745, calories: 8484, price: 84848, image: .afroHeader, buttonTapHandler: { _ in
                
            }),
            .init(type: .delete, dishName: "ejdjejejefj", rating: 74745, calories: 8484, price: 84848, image: .afroHeader, buttonTapHandler: { _ in
                
            }),
            .init(type: .delete, dishName: "ejdjejejefj", rating: 74745, calories: 8484, price: 84848, image: .afroHeader, buttonTapHandler: { _ in
                
            }),
            .init(type: .delete, dishName: "ejdjejejefj", rating: 74745, calories: 8484, price: 84848, image: .afroHeader, buttonTapHandler: { _ in
                
            })
        ])
    }
}

extension AdminDishesPresenter: AdminNewDishPresenterOutput {
    func didCreateNewDish() {
    }
}
