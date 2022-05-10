//
//  ConsumerDataBaseService.swift
//  AfroRestaurant
//
//  Created by Ebubechukwu Dimobi on 09.05.2022.
//  Copyright © 2022 AfroRestaurant. All rights reserved.
//
import Foundation
import FirebaseFirestore
import Firebase

extension ConsumerDataBaseService {
    struct ConsumerDishMinimalModel: Hashable {
        let dishName: String
        let categoryName: String
    }
    
    struct CartModelMinimal {
        let minimalModel: ConsumerDishMinimalModel
        let quantity: Int
        let date: Date?
    }
    
    struct UserDetails {
        let userName: String
        let address: String
        let phoneNumber: String
        let email: String
    }
}

protocol ConsumerDataBaseServiceProtocol: AnyObject {
    func getUserDetails(completion: @escaping (ConsumerDataBaseService.UserDetails?) -> ())
    func loadCategories(completion: @escaping ([CategoryModel]?) -> ())
    func addDishToFavorite(model: ConsumerDataBaseService.ConsumerDishMinimalModel)
    func addDishToCart(model: ConsumerDataBaseService.CartModelMinimal)
    func updateDishToCart(model: ConsumerDataBaseService.CartModelMinimal)
    func removeDishFromFavorite(dishModel: ConsumerDataBaseService.ConsumerDishMinimalModel, completion: @escaping () -> Void)
    func removeDishFromCart(dishModel: ConsumerDataBaseService.ConsumerDishMinimalModel, completion: @escaping () -> Void)
    func loadFavorites(completion: @escaping ([DishModel]?) -> ())
    func loadCarts(completion: @escaping ([CartModel]?) -> ())
    func loadDishes(for categoryName: String, completion: @escaping ([DishModel]?) -> Void)
    func loadDish(dishName: String, for categoryName: String, completion: @escaping (DishModel?) -> Void)
    func set(phoneNumber: String, address: String, name: String)
    
    
    func isDishInCart(dishModel: DishModel) -> Bool
    func isDishInFavorites(dishModel: DishModel) -> Bool
}

final class ConsumerDataBaseService {
    
    let lock = NSRecursiveLock()
    
    private var favorites = [ConsumerDishMinimalModel]()
    private var carts = [CartModelMinimal]()
    
    let adminService: AdminDataBaseServiceProtocol
    
    private var dishesContainer = [String: [DishModel]]()
    private var userID: String {
        Firebase.Auth.auth().currentUser?.uid ?? ""
    }
    
    var email: String {
        Firebase.Auth.auth().currentUser?.email ?? ""
    }
    
    init(adminDataBaseService: AdminDataBaseServiceProtocol) {
        self.adminService = adminDataBaseService
        loadFavoritesFromDataBase { _ in }
        loadCartsFromDataBase { _ in }
    }
    
    private func deleteSavedDocuments(documents: [QueryDocumentSnapshot]?) {
        guard let documents = documents else { return }
        for document in documents {
            document.reference.delete()
        }
    }
    
    private func addFavoriteLocally(model: ConsumerDishMinimalModel) {
        lock.lock()
        defer { lock.unlock() }
        
        favorites.removeAll(where: { $0.dishName == model.dishName })
        favorites.append(model)
    }
    
    private func addCartLocally(model: CartModelMinimal) {
        lock.lock()
        defer { lock.unlock() }
        
        carts.removeAll(where: { $0.minimalModel.dishName == model.minimalModel.dishName })
        carts.append(model)
    }
    
    private func updateCartLocally(model: CartModelMinimal) {
        lock.lock()
        defer { lock.unlock() }
        
        guard let oldCart = carts.first(where: { $0.minimalModel.dishName == model.minimalModel.dishName }) else { return }
        carts.removeAll(where: { $0.minimalModel.dishName == model.minimalModel.dishName })
        carts.append(.init(minimalModel: oldCart.minimalModel, quantity: model.quantity, date: oldCart.date))
    }
    
    private func removeFavoriteLocally(model: ConsumerDishMinimalModel) {
        lock.lock()
        defer { lock.unlock() }
        
        favorites.removeAll(where: { $0.dishName == model.dishName })
    }
    
    private func removeCartLocally(model: ConsumerDishMinimalModel) {
        lock.lock()
        defer { lock.unlock() }
        
        carts.removeAll(where: { $0.minimalModel.dishName == model.dishName })
    }
    
    private func updateAllFavoritesLocally(models: [ConsumerDishMinimalModel]){
        lock.lock()
        defer { lock.unlock() }
        
        favorites = models
    }
    
    private func updateAllCartsLocally(models: [CartModelMinimal]) {
        lock.lock()
        defer { lock.unlock() }
        
        carts = models
    }
    
    private func getFavoritesDocument(for dishName: String) -> DocumentReference {
        Firestore
            .firestore()
            .collection("Users")
            .document(userID)
            .collection("Favorites")
            .document(dishName)
    }
    
    private func getCartDocument(for dishName: String) -> DocumentReference {
        Firestore
            .firestore()
            .collection("Users")
            .document(userID)
            .collection("Cart")
            .document(dishName)
    }
    
    private func getFavorites() -> [DishModel] {
        lock.lock()
        defer { lock.unlock() }
        
        return favorites.compactMap {
            return adminService
                .getDishModel(dishName: $0.dishName, categoryName: $0.categoryName)
        }
    }
    
    private func getCarts() -> [CartModel] {
        lock.lock()
        defer { lock.unlock() }
        
        return carts.compactMap {
            guard
                let model =  adminService
                    .getDishModel(dishName: $0.minimalModel.dishName, categoryName: $0.minimalModel.categoryName)
            else { return nil }
            
            return .init(dishModel: model, quantity: $0.quantity, date: $0.date ?? Date())
        }
    }
    
}

extension ConsumerDataBaseService: ConsumerDataBaseServiceProtocol {
    
    func getUserDetails(completion: @escaping (UserDetails?) -> ()) {
        Firestore
            .firestore()
            .collection("Users")
            .document(userID)
            .getDocument { [weak self] querySnapShot, error in
                guard
                    let self = self,
                    error == nil,
                    let querySnapShot = querySnapShot,
                    let data = querySnapShot.data()
                else {
                    let details = UserDetails(
                        userName: "",
                        address: "",
                        phoneNumber: "",
                        email: self?.email ?? ""
                    )
                    completion(details)
                    return
                }
                
                let details = UserDetails(
                    userName: data["userName"] as? String ?? "",
                    address: data["address"] as? String ?? "",
                    phoneNumber: data["phoneNumber"] as? String ?? "",
                    email: self.email
                )
                completion(details)
            }
    }
    
    func addDishToFavorite(model: ConsumerDishMinimalModel) {
        let FavoriteDocument = getFavoritesDocument(for: model.dishName)
        FavoriteDocument
            .setData([
                "dishName" : model.dishName,
                "categoryName" : model.categoryName
            ], merge: true)
        addFavoriteLocally(model: model)
        loadFavoritesFromDataBase(completion: { _ in })
    }
    
    func addDishToCart(model: CartModelMinimal) {
        let cartDocument = getCartDocument(for: model.minimalModel.dishName)
        cartDocument
            .setData([
                "dishName" : model.minimalModel.dishName,
                "categoryName" : model.minimalModel.categoryName,
                "quantity": model.quantity,
                "dateAdded": Date()
            ], merge: true)
        addCartLocally(model: model)
        loadCartsFromDataBase(completion: { _ in })
    }
    
    func updateDishToCart(model: CartModelMinimal) {
        let cartDocument = getCartDocument(for: model.minimalModel.dishName)
        cartDocument
            .setData([
                "dishName" : model.minimalModel.dishName,
                "categoryName" : model.minimalModel.categoryName,
                "quantity": model.quantity,
            ], merge: true)
        updateCartLocally(model: model)
        loadCartsFromDataBase(completion: { _ in })
    }
    
    func removeDishFromFavorite(dishModel: ConsumerDishMinimalModel, completion: @escaping () -> Void) {
        let queriedCollection = Firestore
            .firestore()
            .collection("Users")
            .document(userID)
            .collection("Favorites")
            .whereField("dishName", isEqualTo: dishModel.dishName)
        
        queriedCollection.getDocuments { [weak self] (querySnapShot, error) in
            defer { completion() }
            guard error == nil,
                  let querySnapShot = querySnapShot else { return }
            if !querySnapShot.documents.isEmpty {
                self?.deleteSavedDocuments(documents: querySnapShot.documents)
                self?.removeFavoriteLocally(model: dishModel)
                self?.loadFavoritesFromDataBase(completion: { _ in })
            }
        }
    }
    
    func removeDishFromCart(dishModel: ConsumerDishMinimalModel, completion: @escaping () -> Void) {
        let queriedCollection = Firestore
            .firestore()
            .collection("Users")
            .document(userID)
            .collection("Cart")
            .whereField("dishName", isEqualTo: dishModel.dishName)
        
        queriedCollection.getDocuments { [weak self] (querySnapShot, error) in
            defer { completion() }
            guard error == nil,
                  let querySnapShot = querySnapShot else { return }
            if !querySnapShot.documents.isEmpty {
                self?.deleteSavedDocuments(documents: querySnapShot.documents)
                self?.removeCartLocally(model: dishModel)
                self?.loadCartsFromDataBase(completion: { _ in })
            }
        }
    }
    
    func isDishInCart(dishModel: DishModel) -> Bool {
        lock.lock()
        defer { lock.unlock() }
        return carts.contains(where: { $0.minimalModel.dishName == dishModel.dishName })
    }
    
    func isDishInFavorites(dishModel: DishModel) -> Bool {
        lock.lock()
        defer { lock.unlock() }
        return favorites.contains(where: { $0.dishName == dishModel.dishName })
    }
    
    func loadCategories(completion: @escaping ([CategoryModel]?) -> ()) {
        adminService.loadCategories(completion: completion)
    }
    
    func loadCartsFromDataBase(completion: @escaping ([CartModel]?) -> ()) {
        
        guard Firebase.Auth.auth().currentUser != nil else { return }
        
        var carts = [CartModelMinimal]()
        Firestore
            .firestore()
            .collection("Users")
            .document(userID)
            .collection("Cart")
            .getDocuments { [weak self] querySnapshot, error in
                guard
                    let self = self,
                    error == nil,
                    let querySnapshot = querySnapshot
                else {
                    completion(nil)
                    return
                }
                
                for category in querySnapshot.documents {
                    let data = category.data()
                    
                    guard
                        let categoryName = data["categoryName"] as? String,
                        let dishName = data["dishName"] as? String,
                        let quantity = data["quantity"] as? Int
                    else { break }
                    
                    carts.append(.init(
                        minimalModel: ConsumerDishMinimalModel(
                            dishName: dishName,
                            categoryName: categoryName
                        ),
                        quantity: quantity,
                        date: data["dateAdded"] as? Date  ?? Date()
                    )
                    )
                }
                self.updateAllCartsLocally(models: carts)
                completion(self.getCarts())
            }
    }
    
    func loadCarts(completion: @escaping ([CartModel]?) -> ()) {
        loadFavoritesFromDataBase { _ in }
        loadCartsFromDataBase { _ in }
        lock.lock()
        defer { lock.unlock() }
        guard
            carts.isEmpty
        else {
            completion(getCarts())
            return
        }
        loadCartsFromDataBase(completion: completion)
    }
    
    
    func loadFavoritesFromDataBase(completion: @escaping ([DishModel]?) -> ()) {
        
        guard Firebase.Auth.auth().currentUser != nil else { return }
        
        var favorites = [ConsumerDishMinimalModel]()
        Firestore
            .firestore()
            .collection("Users")
            .document(userID)
            .collection("Favorites")
            .getDocuments { [weak self] querySnapshot, error in
                guard
                    let self = self,
                    error == nil,
                    let querySnapshot = querySnapshot
                else {
                    completion(nil)
                    return
                }
                
                for category in querySnapshot.documents {
                    let data = category.data()
                    
                    guard
                        let categoryName = data["categoryName"] as? String,
                        let dishName = data["dishName"] as? String
                    else { break }
                    
                    favorites.append(.init(dishName: dishName, categoryName: categoryName))
                }
                self.updateAllFavoritesLocally(models: favorites)
                completion(self.getFavorites())
            }
    }
    
    func loadFavorites(completion: @escaping ([DishModel]?) -> ()) {
        loadFavoritesFromDataBase { _ in }
        loadCartsFromDataBase { _ in }
        
        lock.lock()
        defer { lock.unlock() }
        guard
            favorites.isEmpty
        else {
            completion(getFavorites())
            return
        }
        loadFavoritesFromDataBase(completion: completion)
    }
    
    func loadDishes(for categoryName: String, completion: @escaping ([DishModel]?) -> Void) {
        adminService.loadDishes(for: categoryName, completion: completion)
    }
    
    func loadDish(dishName: String, for categoryName: String, completion: @escaping (DishModel?) -> Void) {
        adminService.loadDish(dishName: dishName, for: categoryName, completion: completion)
    }
    
    func set(phoneNumber: String, address: String, name: String) {
        Firestore.firestore().collection("Users").document(userID).setData([
            "phoneNumber" : phoneNumber,
            "address": address,
            "userName": name
        ])
    }
}

