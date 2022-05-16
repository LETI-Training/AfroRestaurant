import UIKit

protocol AdminDishViewViewInput: AnyObject {
    func presentAlert(
        title: String,
        message: String,
        action: ActionAlertModel?,
        action2: ActionAlertModel?
    )
    func presentAlert(title: String, message: String, action: ActionAlertModel?)
    func updateUI(model: DishModel)
    func updateImage(image: UIImage?)
    func updateLikes(likesCount: Int)
    func updateRatings(rating: Double)
}
