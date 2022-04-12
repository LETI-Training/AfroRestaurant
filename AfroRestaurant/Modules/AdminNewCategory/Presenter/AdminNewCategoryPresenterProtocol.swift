protocol AdminNewCategoryPresenterProtocol: AnyObject {
    func viewDidLoad()
    func createCategoryButtonTapped(categoryName: String?, categoryDescription: String?)
    func cancelTapped()
}

protocol AdminNewCategoryPresenterOutput: AnyObject {
    func didCreateNewCategory()
}
