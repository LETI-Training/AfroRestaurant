protocol AdminNewDishPresenterProtocol: AnyObject {
    func viewDidLoad()
    func createDishButtonTapped(dishName: String, description: String, calories: String, price: String)
    func cancelTapped()
    func addPhotoTapped()
}

protocol AdminNewDishPresenterOutput: AnyObject {
    func didCreateNewDish()
}
