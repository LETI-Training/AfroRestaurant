protocol ConsumerProfileInteractorInput: AnyObject {
    func getUserDetails(completion: @escaping (ConsumerDataBaseService.UserDetails?) -> ())
    func logout()
    func set(phoneNumber: String, address: String, name: String)
}
