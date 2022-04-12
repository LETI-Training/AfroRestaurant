protocol AdminInventoryPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didSelectItem(at row: Int)
    func didDeleteItem(at row: Int)
    func didTapAddNewCategory()
    func viewDidAppear()
}
