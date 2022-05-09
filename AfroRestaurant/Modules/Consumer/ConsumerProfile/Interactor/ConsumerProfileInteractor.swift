class ConsumerProfileInteractor {
    let consumerDataBase: ConsumerDataBaseServiceProtocol
    private let authService: AuthorizationServiceInput
    
    init(
        consumerDataBase: ConsumerDataBaseServiceProtocol,
        authService: AuthorizationServiceInput
    ) {
        self.consumerDataBase = consumerDataBase
        self.authService = authService
    }
}

extension ConsumerProfileInteractor: ConsumerProfileInteractorInput {
    func getUserDetails(completion: @escaping (ConsumerDataBaseService.UserDetails?) -> ()) {
        consumerDataBase.getUserDetails(completion: completion)
    }
    
    func logout() {
        authService.signOut()
    }
    
    func set(phoneNumber: String, address: String, name: String) {
        consumerDataBase.set(phoneNumber: phoneNumber, address: address, name: name)
    }
}
