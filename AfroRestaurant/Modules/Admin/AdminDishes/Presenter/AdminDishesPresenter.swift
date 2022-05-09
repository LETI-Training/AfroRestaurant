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
            let dishModel = $0
            return DishesCollectionViewCell.ViewModel(
                type: .delete,
                dishName: $0.dishName,
                rating: $0.rating ?? 0.0,
                calories: $0.calories,
                price: $0.price,
                image: UIImage(data: data)
            ) { [weak self] viewModel in
                self?.deleteDish(viewModel: dishModel)
            }
        }
        DispatchQueue.main.async {
            self.view?.updateItems(description: self.category.categoryDescription, viewModels: viewModel)
        }
    }
    
    private func deleteDish(viewModel: DishModel) {
        view?.presentAlert(
            title: "Deletion",
            message: "Are you sure you want to delete",
            action: .init(actionText: "No", actionHandler: {}),
            action2: .init(actionText: "Yes", actionHandler: { [weak self] in
                guard let self = self else { return }
                self.interactor?.deleteDish(viewModel.dishName, in: self.category.categoryName, completion: {
                    self.loadDishes()
                })
            })
        )
    }
}

extension AdminDishesPresenter: AdminDishesPresenterProtocol {
    func viewWillAppear() {
        loadDishes()
    }
    
    func dishTapped(at index: Int) {
        router?.routeToDishe(dish: category.dishes[index], categoryName: category.categoryName)
    }
    
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
