import UIKit
protocol AdminDishViewPresenterProtocol: AnyObject {
    func viewDidLoad()
    func saveButtonPressed(
        image: UIImage?,
        dishName: String,
        description: String,
        calories: String,
        price: String
    )
    func deleteTapped()
    func addPhotoTapped()
}
