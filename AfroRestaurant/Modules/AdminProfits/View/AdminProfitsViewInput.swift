protocol AdminProfitsViewInput: AnyObject {
    func updateUI(totalProfits: String)
    func updateItems(viewModels: [AdminProfitsTableViewCell.ViewModel])
}
