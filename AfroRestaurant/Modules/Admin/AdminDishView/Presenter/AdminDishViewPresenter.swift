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
        interactor?.deleteDish(dishModel.dishName, in: categoryName, completion: { [weak self] in
            self?.router?.dismiss()
        })
    }
    
    func addPhotoTapped() {
        if #available(iOS 14, *) {
            router?.openPhotos(delegate: self)
        } else {
            router?.routeToImagePicker(delegate: self)
        }
    }
    

    func viewDidLoad() {
        view?.updateUI(model: dishModel)
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
