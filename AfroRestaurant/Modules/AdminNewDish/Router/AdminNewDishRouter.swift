import UIKit
import Photos
import PhotosUI

class AdminNewDishRouter {
    weak var view: UIViewController?
    
    func dismiss() {
        view?.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func openPhotos(delegate: PHPickerViewControllerDelegate) {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 1
        config.filter = .images
        let vc = PHPickerViewController(configuration: config)
        vc.delegate = delegate
        view?.present(vc, animated: true, completion: nil)
    }
}
