import Foundation

class ConsumerProfilePresenter {
    weak var view: ConsumerProfileViewInput?
    var interactor: ConsumerProfileInteractorInput?
    var router: ConsumerProfileRouter?

    init() {}
}

extension ConsumerProfilePresenter: ConsumerProfilePresenterProtocol {
    func saveButtonPressed(name: String, phoneNumber: String, address: String) {
        guard
            !name.isEmpty,
            !phoneNumber.isEmpty,
            !address.isEmpty
        else {
            view?.presentAlert(
                title: "Error",
                message: "Please Fill All Fields",
                action: .init(actionText: "Ok", actionHandler: {}),
                action2: nil
            )
            return
        }
        interactor?.set(phoneNumber: phoneNumber, address: address, name: name)
    }
    
    func logoutTapped() {
        interactor?.logout()
    }
    
    func viewDidLoad() {
        interactor?.getUserDetails(completion: { [weak self] details in
            guard let details = details else { return }
            
            DispatchQueue.main.async {
                self?.view?.updateView(model: details)
            }
        })
    }
}
