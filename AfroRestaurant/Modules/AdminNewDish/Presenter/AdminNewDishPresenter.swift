import UIKit
import PhotosUI

class AdminNewDishPresenter: NSObject {
    weak var view: AdminNewDishViewInput?
    var interactor: AdminNewDishInteractorInput?
    var router: AdminNewDishRouter?

    let category: AdminCreateCategoryModel
    weak var output: AdminNewDishPresenterOutput?
    
    var image: UIImage?
    
    init(category: AdminCreateCategoryModel, output: AdminNewDishPresenterOutput) {
        self.category = category
        self.output = output
    }
}

extension AdminNewDishPresenter: AdminNewDishPresenterProtocol {
    func addPhotoTapped() {
        if #available(iOS 14, *) {
            router?.openPhotos(delegate: self)
        } else {
            router?.routeToImagePicker(delegate: self)
        }
    }
    
    func createDishButtonTapped(
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
        
        interactor?.createNewDish(
            dishModel: .init(
                category: category,
                dishName: dishName,
                dishDescription: description,
                calories: calories,
                price: price,
                imageString: imageString ?? ""
            )
        )
        output?.didCreateNewDish()
        router?.dismiss()
    }
    
    func cancelTapped() {
        router?.dismiss()
    }
    

    func viewDidLoad() {}
}

extension AdminNewDishPresenter: PHPickerViewControllerDelegate {
    @available(iOS 14, *)
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        results.forEach { result in
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] reading, _ in
                self?.image = reading as? UIImage
                self?.view?.updateImage(image: self?.image)
            }
        }
    }
}

extension AdminNewDishPresenter: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        image = info[.editedImage] as? UIImage
        view?.updateImage(image: image)
        picker.dismiss(animated: true, completion: nil)
    }
}
