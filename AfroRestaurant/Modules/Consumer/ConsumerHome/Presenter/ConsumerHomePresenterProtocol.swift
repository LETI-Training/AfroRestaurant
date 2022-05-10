import Foundation

protocol ConsumerHomePresenterProtocol: AnyObject {
    func viewDidLoad()
    func viewWillAppear()
    func dishTapped(at indexPath: IndexPath)
    func myOrdersButtonPressed()
}
