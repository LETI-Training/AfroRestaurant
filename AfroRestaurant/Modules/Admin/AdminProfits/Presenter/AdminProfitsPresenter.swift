class AdminProfitsPresenter {
    weak var view: AdminProfitsViewInput?
    var interactor: AdminProfitsInteractorInput?
    var router: AdminProfitsRouter?

    init() {}
}

extension AdminProfitsPresenter: AdminProfitsPresenterProtocol {

    func viewDidLoad() {
        view?.updateUI(totalProfits: "RUB 86,365")
        view?.updateItems(viewModels: getProfitsViewModel())
    }
}

extension AdminProfitsPresenter {
    
    func getProfitsViewModel() -> [AdminProfitsTableViewCell.ViewModel] {
        var viewModels = [AdminProfitsTableViewCell.ViewModel]()
        let dishes = ["Peppered chicken", "Beans crayon", "Rice special", "Suya and okro"]
        for orderNumber in 0...232 {
            viewModels.append(
                .init(
                    orderNumber: orderNumber,
                    dish: dishes.randomElement() ?? "",
                    price: .random(in: 200...9590)
                )
            )
        }
        
        return viewModels.reversed()
    }
}
