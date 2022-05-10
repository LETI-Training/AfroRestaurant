class AdminHomeInteractor {
    private let orderDataBase: AdminAnalyticsDataBaseServiceProtocol
    var ordersListener: (([AdminAnalyticsDataBaseService.OrderModel]) -> Void)?
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
}
