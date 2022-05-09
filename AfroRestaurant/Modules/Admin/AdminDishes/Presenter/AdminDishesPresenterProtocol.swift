protocol AdminDishesPresenterProtocol: AnyObject {
    func viewDidLoad()
    func viewWillAppear()
    func createNewDishTapped()
    func dishTapped(at index: Int)
}
