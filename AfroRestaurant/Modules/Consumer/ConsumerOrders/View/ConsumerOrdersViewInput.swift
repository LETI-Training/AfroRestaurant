protocol ConsumerOrdersViewInput: AnyObject {
    func updateItems(viewModels: [ConsumerOrdersViewController.ViewModel])
    func changeSelectedIndex(index: Int)
}
