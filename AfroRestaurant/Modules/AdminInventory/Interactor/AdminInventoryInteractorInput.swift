protocol AdminInventoryInteractorInput: AnyObject {
    func loadCategories(completion: @escaping ([AdminCategoryModel]?) -> ())
    func deleteCategory(categoryModel: AdminCategoryModel, completion: @escaping () -> Void)
}
