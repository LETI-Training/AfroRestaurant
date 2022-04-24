import Foundation
import UIKit

class AdminDishesPresenter {
    weak var view: AdminDishesViewInput?
    var interactor: AdminDishesInteractorInput?
    var router: AdminDishesRouter?
    
    let category: CategoryModel
    
    init(category: CategoryModel) {
        self.category = category
    }
    
    private func loadDishes() {
        interactor?.loadDishes(for: category.categoryName, completion: { [weak self] model in
            guard let model = model else {
                return
            }
            self?.generateViewModels(for: model)
        })
    }
    
    private func generateViewModels(for dishes: [DishModel]) {
        let viewModel: [DishesCollectionViewCell.ViewModel] = dishes.compactMap {
            let data = Data(base64Encoded: $0.imageString) ?? Data()
            
            return DishesCollectionViewCell.ViewModel(
                type: .delete,
                dishName: $0.dishName,
                rating: $0.rating ?? Double.random(in: 0...5),
                calories: $0.calories,
                price: $0.price,
                image: UIImage(data: data)
            ) { viewModel in
                
            }
            
        }
        DispatchQueue.main.async {
            self.view?.updateItems(description: self.category.categoryDescription, viewModels: viewModel)
        }
    }
}

extension AdminDishesPresenter: AdminDishesPresenterProtocol {
    func createNewDishTapped() {
        router?.presentNewDish(
            output: self,
            category: .init(categoryName: category.categoryName, categoryDescription: category.categoryName)
        )
    }
    
    func viewDidLoad() {
        view?.updateTitle(title: category.categoryName)
        generateViewModels(for: category.dishes)
    }
}

extension AdminDishesPresenter: AdminNewDishPresenterOutput {
    func didCreateNewDish() {
        loadDishes()
    }
}
