protocol ConsumerCartViewInput: AnyObject {
    func updateItems(viewModels: [ConsumerCartViewController.ViewModel], cartCount: Int)
}
