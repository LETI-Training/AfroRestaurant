import UIKit
import PhotosUI

class AdminNewDishPresenter {
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
        router?.openPhotos(delegate: self)
    }
    
    func createDishButtonTapped(
        dishName: String,
        description: String,
        calories: String,
        price: String
    ) {
        
    }
    
    func cancelTapped() {
        
    }
    

    func viewDidLoad() {
    }
}

extension AdminNewDishPresenter: PHPickerViewControllerDelegate {
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
