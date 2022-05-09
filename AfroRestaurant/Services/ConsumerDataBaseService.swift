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

protocol ConsumerDataBaseServiceProtocol {
    var userName: String { get }
    var email: String { get }
    var phoneNumber: String { get }
    
    func loadCategories(completion: @escaping ([CategoryModel]?) -> ())
    func addDishToFavorite(dishModel: DishModel)
    func addDishToCart(dishModel: DishModel, quantity: Int)
    func removeDishFromFavorite(dishModel: DishModel, completion: @escaping () -> Void)
    func removeDishFromCart(dishModel: DishModel, completion: @escaping () -> Void)
    func loadFavorites(completion: @escaping ([DishModel]?) -> ())
    func loadDishes(for categoryName: String, completion: @escaping ([DishModel]?) -> Void)
    func loadDish(dishName: String, for categoryName: String, completion: @escaping (DishModel?) -> Void)
    func setPhoneNumber(phoneNumber: String)
    
    func isDishInCart(dishModel: DishModel) -> CartModel?
    func isDishInFavorites(dishModel: DishModel) -> Bool
}

final class ConsumerDataBaseService {
    
    let lock = NSConditionLock()
    
    let adminService: AdminDataBaseServiceProtocol
    
    private var dishesContainer = [String: [DishModel]]()
    private var categories = [CategoryModel]()
    private let userID = Firebase.Auth.auth().currentUser?.uid ?? ""
    
    let userName: String = {
        Firebase.Auth.auth().currentUser?.displayName ?? ""
    }()
    
    let email: String = {
        Firebase.Auth.auth().currentUser?.email ?? ""
    }()
    
    let phoneNumber: String = {
        ""
    }()
    
    init(adminDataBaseService: AdminDataBaseServiceProtocol) {
        self.adminService = adminDataBaseService
//        loadCategoriesFromDataBase { _ in }
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
    
}

extension ConsumerDataBaseService: ConsumerDataBaseServiceProtocol {
    func addDishToFavorite(dishModel: DishModel) {
        
    }
    
    func addDishToCart(dishModel: DishModel, quantity: Int) {
        
    }
    
    func removeDishFromFavorite(dishModel: DishModel, completion: @escaping () -> Void) {
        
    }
    
    func removeDishFromCart(dishModel: DishModel, completion: @escaping () -> Void) {
        
    }
    
    func isDishInCart(dishModel: DishModel) -> CartModel? {
        nil
    }
    
    func isDishInFavorites(dishModel: DishModel) -> Bool {
        false
    }
    
    func loadCategories(completion: @escaping ([CategoryModel]?) -> ()) {
        adminService.loadCategories(completion: completion)
    }
    
    func loadFavorites(completion: @escaping ([DishModel]?) -> ()) {
        completion(nil)
    }
    
    func loadDishes(for categoryName: String, completion: @escaping ([DishModel]?) -> Void) {
        adminService.loadDishes(for: categoryName, completion: completion)
    }
    
    func loadDish(dishName: String, for categoryName: String, completion: @escaping (DishModel?) -> Void) {
        adminService.loadDish(dishName: dishName, for: categoryName, completion: completion)
    }
    
    func setPhoneNumber(phoneNumber: String) {
        Firestore.firestore().collection("Users").document(userID).setData([
            "phoneNumber" : phoneNumber
        ])
    }
}

