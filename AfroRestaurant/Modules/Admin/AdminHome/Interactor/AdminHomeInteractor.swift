class AdminHomeInteractor {
    private let orderDataBase: AdminAnalyticsDataBaseServiceProtocol
    var ordersListener: (([AdminAnalyticsDataBaseService.OrderModel]) -> Void)?
    var updatesListener: (([UpdateModel]) -> Void)?
    var restaurantRatingListener: ((Double) -> Void)?
    private let authService: AuthorizationServiceInput?
    var authErrorListner: ((_ errorText: String) -> Void)?
    
    init(
        authService: AuthorizationServiceInput?,
        orderDataBase: AdminAnalyticsDataBaseServiceProtocol
    ) {
        self.authService = authService
        self.orderDataBase = orderDataBase
        
        authService?.addListner(self)
        orderDataBase.addListner(self)
    }
    
    deinit {
        authService?.removeListner(self)
        orderDataBase.removeListner(self)
    }
}

extension AdminHomeInteractor: AdminHomeInteractorInput {
    func loadOrders() {
        orderDataBase.loadOrders()
    }
    
    func performLogout() {
        authService?.signOut()
    }
    
    func loadAllUpdates() {
        orderDataBase.loadAllUpdates()
    }
    
    func loadRestaurantRating() {
        orderDataBase.loadRestaurantRatingsAverage()
    }
}

extension AdminHomeInteractor: AuthorizationServiceOutput {
    func authorizationService(didFailWith error: AuthorizationService.ErrorType) {
        switch error {
            
        case .logout(error: let error):
            authErrorListner?(error.localizedDescription)
        case .register, .login, .passwordReset:
            break
        }
    }
}

extension AdminHomeInteractor: AdminAnalyticsDataBaseServiceOutput {
    func adminService(didFinishLoading orderModels: [AdminAnalyticsDataBaseService.OrderModel]) {
        ordersListener?(orderModels)
    }
    
    func adminService(didFinishLoadingLikes likesCount: Int, for dishName: String, in categoryName: String) {}
    
    func adminService(didFinishLoadingRatings ratingsAverage: Double, for dishName: String, in categoryName: String) {}
    
    func adminService(didFinishLoadingRatingsForRestaurant ratingsAverage: Double) {
        restaurantRatingListener?(ratingsAverage)
    }
    
    func adminService(didFinishLoadingUserDetails: UserDetails) {}
    
    func adminService(didFinishLoadingAllUpdates: [UpdateModel]) {
        updatesListener?(didFinishLoadingAllUpdates)
    }
}
