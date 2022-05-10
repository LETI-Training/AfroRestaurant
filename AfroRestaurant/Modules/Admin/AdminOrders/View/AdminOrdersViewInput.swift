protocol AdminOrdersViewInput: AnyObject {
    func updateItems(viewModels: [AdminOrdersViewController.ViewModel])
    func changeSelectedIndex(index: Int)
}
