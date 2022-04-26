protocol AdminInventoryInteractorInput: AnyObject {
    func loadCategories(completion: @escaping ([CategoryModel]?) -> ())
    func deleteCategory(categoryModel: CategoryModel, completion: @escaping () -> Void)
}
