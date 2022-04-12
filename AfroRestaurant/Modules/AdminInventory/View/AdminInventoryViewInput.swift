protocol AdminInventoryViewInput: AnyObject {
    func updateItems(viewModels: [AdminInventoryTableViewCell.ViewModel])
}
