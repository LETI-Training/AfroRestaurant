protocol ConsumerDishViewPresenterProtocol: AnyObject {
    func viewDidLoad()
    func viewWillAppear()
    func cartButtonTapped()
    func buyMealPressed()
    func addToFavoritesPressed()
    func didTapNewRateView()
}
