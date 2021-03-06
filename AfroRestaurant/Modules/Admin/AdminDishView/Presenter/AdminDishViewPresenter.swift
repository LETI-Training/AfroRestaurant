import UIKit
import PhotosUI

class AdminDishViewPresenter: NSObject {
    weak var view: AdminDishViewViewInput?
    var interactor: AdminDishViewInteractorInput?
    var router: AdminDishViewRouter?
    var dishModel: DishModel
    let categoryName: String
    
    init(dishModel: DishModel, categoryName: String) {
        self.dishModel = dishModel
        self.categoryName = categoryName
    }
}

extension AdminDishViewPresenter: AdminDishViewPresenterProtocol {
    func saveButtonPressed(
        image: UIImage?,
        dishName: String,
        description: String,
        calories: String,
        price: String
    ) {
        guard
            !dishName.isEmpty,
            !description.isEmpty,
            let calories = Int(calories),
            let price = Double(price)
        else {
            view?.presentAlert(
                title: "Error",
                message: "Please Fill All Fields",
                action: .init(actionText: "Ok", actionHandler: {})
            )
            return
        }
        
        let imageString = image?
            .jpegData(compressionQuality: 0.1)?
            .base64EncodedString()
        
        let createDishModel = AdminCreateDishModel(
            category: AdminCreateCategoryModel(categoryName: categoryName, categoryDescription: ""),
            dishName: dishName,
            dishDescription: description,
            calories: calories,
            price: price,
            imageString: imageString ?? ""
        )
        interactor?.updateDishToCategory(dishModel: createDishModel)
        interactor?.loadDish(dishName: dishName, for: categoryName, completion: { [weak self] dishModel in
            guard
                let self = self,
                let dishModel = dishModel
            else { return }
            self.dishModel = dishModel
            self.view?.updateUI(model: dishModel)
        })
    }
    
    func deleteTapped() {
        view?.presentAlert(
            title: "Deletion",
            message: "Are you sure you want to delete",
            action: .init(actionText: "No", actionHandler: {}),
            action2: .init(actionText: "Yes", actionHandler: { [weak self] in
                guard let self = self else { return }
                self.interactor?.deleteDish(self.dishModel.dishName, in: self.categoryName, completion: { [weak self] in
                    self?.router?.dismiss()
                })
            })
        )
    }
    
    func addPhotoTapped() {
        if #available(iOS 14, *) {
            router?.openPhotos(delegate: self)
        } else {
            router?.routeToImagePicker(delegate: self)
        }
    }
    
    
    func viewDidLoad() {
        
        interactor?.likesListener = { [weak self] likes, dish, category  in
            guard
                dish == self?.dishModel.dishName,
                category == self?.dishModel.categoryName else { return }
            
            self?.view?.updateLikes(likesCount: likes)
        }
        
        interactor?.ratingsListener = { [weak self] ratings, dish, category  in
            guard
                dish == self?.dishModel.dishName,
                category == self?.dishModel.categoryName else { return }
            
            self?.view?.updateRatings(rating: ratings)
        }
        view?.updateUI(model: dishModel)
        interactor?.loadLikesCount(dishname: dishModel.dishName, in: dishModel.categoryName)
        interactor?.loadRatingsCount(dishName: dishModel.dishName, in: dishModel.categoryName)
    }
    
    func viewWillAppear() {
        interactor?.loadLikesCount(dishname: dishModel.dishName, in: dishModel.categoryName)
        interactor?.loadRatingsCount(dishName: dishModel.dishName, in: dishModel.categoryName)
        interactor?.loadDish(dishName: dishModel.dishName, for: categoryName, completion: { [weak self] dishModel in
            guard
                let self = self,
                let dishModel = dishModel
            else { return }
            self.dishModel = dishModel
            self.view?.updateUI(model: dishModel)
        })
    }
    
}

extension AdminDishViewPresenter: PHPickerViewControllerDelegate {
    @available(iOS 14, *)
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        results.forEach { result in
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] reading, _ in
                self?.view?.updateImage(image: reading as? UIImage)
            }
        }
    }
}

extension AdminDishViewPresenter: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        view?.updateImage(image: info[.editedImage] as? UIImage)
        picker.dismiss(animated: true, completion: nil)
    }
}
