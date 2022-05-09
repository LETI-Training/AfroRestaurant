import UIKit
import Photos
import PhotosUI

class AdminDishViewRouter {
    weak var view: UIViewController?
    
    func dismiss() {
        view?.navigationController?.popViewController(animated: true)
    }
    
    @available(iOS 14, *)
    func openPhotos(delegate: PHPickerViewControllerDelegate) {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 1
        config.filter = .images
        let vc = PHPickerViewController(configuration: config)
        vc.delegate = delegate
        view?.present(vc, animated: true, completion: nil)
    }
    
    func routeToImagePicker(delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = delegate
            imagePickerController.allowsEditing = true
            imagePickerController.sourceType = .photoLibrary
            view?.navigationController?.present(imagePickerController, animated: true, completion: nil)
        }
    }
}
