import UIKit

protocol AdminNewDishViewInput: AnyObject {
    func presentAlert(title: String, message: String, action: ActionAlertModel?)
    func updateImage(image: UIImage?)
}
