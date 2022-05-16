//
//  AdminAnalyticsDataBaseService.swift
//  AfroRestaurant
//
//  Created by Ebubechukwu Dimobi on 10.05.2022.
//  Copyright © 2022 AfroRestaurant. All rights reserved.
//

import Foundation
import Foundation
import FirebaseFirestore
import Firebase
import UIKit

struct UpdateModel {
    let rating: Double
    let dishname: String
    let type: UpdateType
    let userName: String
    let date: Date
}

enum UpdateType: String {
    case rating, likes
}

extension AdminAnalyticsDataBaseService {
    struct OrderCreateModel {
        let dishModels: [DishOrderModel]
        let userDetails: ConsumerDataBaseService.UserDetails
        let date: Date
        let type: OrderStatus
    }
    
    struct OrderModel {
        let orderNumber: String
        let dishModels: [DishOrderModel]
        let userDetails: ConsumerDataBaseService.UserDetails
        let date: Date
        let type: OrderStatus
        let userID: String
    }
    
    struct DishOrderModel {
        let dishName: String
        let price: Double
        let quantity: Int
    }
    
    enum OrderStatus: String, Codable, Equatable {
        case delivered
        case cancelled
        case created
    }
}


protocol AdminAnalyticsDataBaseServiceProtocol: AnyObject {
    var tabBar: UITabBarController? { get set }
    
    func addListner(_ listener: AdminAnalyticsDataBaseServiceOutput)
    func removeListner(_ listener: AdminAnalyticsDataBaseServiceOutput)
    func createOrder(model: AdminAnalyticsDataBaseService.OrderCreateModel)
    func updateOrderStatus(status: AdminAnalyticsDataBaseService.OrderStatus, orderNumber: String)
    func loadOrders()
    func loadOrdersForCurrentUser()
    func likeDish(dishname: String, categoryName: String)
    func unlikeDish(dishname: String, categoryName: String)
    func rateDish(rating: Double, dishname: String, categoryName: String)
    
    func loadLikesCount(dishname: String, in categoryName: String)
    func loadRatingsCount(dishName: String, in categoryName: String)
    func loadRestaurantRatingsAverage()
    func loadAllUpdates()
    func getUserDetails(completion: @escaping (UserDetails?) -> ()) 
}

protocol AdminAnalyticsDataBaseServiceOutput: AnyObject {
    func adminService(didFinishLoading orderModels: [AdminAnalyticsDataBaseService.OrderModel])
    func adminService(didFinishLoadingLikes likesCount: Int, for dishName: String, in categoryName: String)
    func adminService(didFinishLoadingRatings ratingsAverage: Double, for dishName: String, in categoryName: String)
    func adminService(didFinishLoadingRatingsForRestaurant ratingsAverage: Double)
    func adminService(didFinishLoadingUserDetails: UserDetails)
    func adminService(didFinishLoadingAllUpdates: [UpdateModel])
}

final class AdminAnalyticsDataBaseService {
    private var outputs: [WeakRefeferenceWrapper<AdminAnalyticsDataBaseServiceOutput>] = []
    private let updateLock = NSRecursiveLock()
    private var userDetails: UserDetails?
    
    private let userType: UserType
    
    private var userID: String {
        Firebase.Auth.auth().currentUser?.uid ?? ""
    }
    
    var email: String {
        Firebase.Auth.auth().currentUser?.email ?? ""
    }
    
    weak var tabBar: UITabBarController? {
        didSet {
            switch userType {
            case .customer:
                loadOrdersForCurrentUser()
            case .admin:
                loadOrders()
            }
        }
    }
    
    init(userType: UserType) {
        self.userType = userType
        setupListner()
    }
    
    private func updateUserDetails() {
        getUserDetails { [weak self] userDetails in
            self?.userDetails = userDetails
        }
    }
    
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
    
    private func setupListner() {
        Firestore
            .firestore()
            .collection("Restaurants")
            .document("AfroRestaurant")
            .collection("Orders")
            .addSnapshotListener { [weak self] _, _ in
                // firebase is slow to update all
                DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 1.3) {
                    switch self?.userType {
                    case .customer:
                        self?.loadOrdersForCurrentUser()
                    case .admin:
                        self?.loadOrders()
                    case .none:
                        break
                    }
                }
            }
        
        Firestore
            .firestore()
            .collection("Restaurants")
            .document("AfroRestaurant")
            .collection("Ratings")
            .addSnapshotListener { [weak self] _, _ in
                DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 1.3) {
                    self?.loadRestaurantRatingsAverage()
                }
            }
        
        Firestore
            .firestore()
            .collection("Restaurants")
            .document("AfroRestaurant")
            .collection("Updates")
            .addSnapshotListener { [weak self] _, _ in
                DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 1.3) {
                    self?.loadAllUpdates()
                }
            }
        
        Firestore
            .firestore()
            .collection("Users")
            .addSnapshotListener { [weak self] _, _ in
                DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 1.3) {
                    guard self?.userID.isEmpty == false else { return }
                    self?.updateUserDetails()
                }
            }
    }
    
    private func getOrderDocument(for orderNumber: String) -> DocumentReference {
        Firestore
            .firestore()
            .collection("Restaurants")
            .document("AfroRestaurant")
            .collection("Orders")
            .document(orderNumber)
    }
    
    func addListner(_ listener: AdminAnalyticsDataBaseServiceOutput) {
        updateLock.lock()
        defer { updateLock.unlock() }
        
        outputs.append(WeakRefeferenceWrapper(object: listener) )
        outputs.removeAll(where: { $0.object == nil })
    }
    
    func removeListner(_ listener: AdminAnalyticsDataBaseServiceOutput) {
        updateLock.lock()
        defer { updateLock.unlock() }
        
        outputs.removeAll(where: { $0.object === listener || $0.object == nil })
    }
    
    private func sendUpdateNotification(orderModels: [OrderModel]) {
        DispatchQueue.main.async {
            let newOrders = orderModels.filter({ $0.type == .created })
            guard let tabItems = self.tabBar?.tabBar.items else { return }
            tabItems[0].badgeValue = newOrders.count <= 0 ? nil : "\(newOrders.count)"
        }
        updateLock.lock()
        defer { updateLock.unlock() }
        
        outputs.forEach {
            $0.object?.adminService(didFinishLoading: orderModels)
        }
    }
    
    private func sendUpdateNotification(likesCount: Int, dishname: String, categoryName: String) {
        updateLock.lock()
        defer { updateLock.unlock() }
        
        outputs.forEach {
            $0.object?.adminService(didFinishLoadingLikes: likesCount, for: dishname, in: categoryName)
        }
    }
    
    private func sendUpdateNotification(ratingsAverage: Double, dishname: String, categoryName: String) {
        updateLock.lock()
        defer { updateLock.unlock() }
        
        outputs.forEach {
            $0.object?.adminService(didFinishLoadingRatings: ratingsAverage, for: dishname, in: categoryName)
        }
    }
    
    private func sendUpdateNotification(userDetails: UserDetails) {
        updateLock.lock()
        defer { updateLock.unlock() }
        
        outputs.forEach {
            $0.object?.adminService(didFinishLoadingUserDetails: userDetails)
        }
    }
    
    private func sendUpdateNotification(restaurantRatings: Double) {
        updateLock.lock()
        defer { updateLock.unlock() }
        
        outputs.forEach {
            $0.object?.adminService(didFinishLoadingRatingsForRestaurant: restaurantRatings)
        }
    }
    
    private func sendUpdateNotification(updates: [UpdateModel]) {
        updateLock.lock()
        defer { updateLock.unlock() }
        
        outputs.forEach {
            $0.object?.adminService(didFinishLoadingAllUpdates: updates)
        }
    }
}

// rates, likes, updates
extension AdminAnalyticsDataBaseService {
    
    func rateDish(rating: Double, dishname: String, categoryName: String) {
        
        deleteQueryForNewUpdate(collectionName: "Ratings", dishName: dishname, category: categoryName) { [weak self] in
            guard let self = self else { return }
            Firestore
                .firestore()
                .collection("Restaurants")
                .document("AfroRestaurant")
                .collection("Ratings")
                .document()
                .setData([
                    "userID": self.userID,
                    "rating" : rating,
                    "dishName": dishname,
                    "categoryName": categoryName,
                    "userName": self.userDetails?.userName ?? ""
                ], merge: true)
            
            self.updateUpdates(dishname: dishname, rating: rating, type: .rating)
        }
    }
    
    func likeDish(dishname: String, categoryName: String) {
        deleteQueryForNewUpdate(collectionName: "Likes", dishName: dishname, category: categoryName) { [weak self] in
            guard let self = self else { return }
            Firestore
                .firestore()
                .collection("Restaurants")
                .document("AfroRestaurant")
                .collection("Likes")
                .document()
                .setData([
                    "userID": self.userID,
                    "dishName": dishname,
                    "categoryName": categoryName,
                    "userName": self.userDetails?.userName ?? ""
                ], merge: true)
            self.updateUpdates(dishname: dishname, rating: nil, type: .likes)
        }
    }
    
    func unlikeDish(dishname: String, categoryName: String) {
        deleteQueryForNewUpdate(collectionName: "Likes", dishName: dishname, category: categoryName, completion: { })
    }
    
    private func updateUpdates(dishname: String, rating: Double?, type: UpdateType) {
        Firestore
            .firestore()
            .collection("Restaurants")
            .document("AfroRestaurant")
            .collection("Updates")
            .document()
            .setData([
                "userID": userID,
                "rating" : rating ?? 0.0,
                "dishName": dishname,
                "updateType": type.rawValue,
                "userName": userDetails?.userName ?? "",
                "dateAdded": Date().timeIntervalSince1970
            ], merge: true)
    }
    
    func loadLikesCount(dishname: String, in categoryName: String) {
        Firestore
            .firestore()
            .collection("Restaurants")
            .document("AfroRestaurant")
            .collection("Likes")
            .whereField("dishName", isEqualTo: dishname)
            .whereField("categoryName", isEqualTo: categoryName)
            .getDocuments { [weak self] querySnapshot, _ in
                self?.sendUpdateNotification(
                    likesCount: querySnapshot?.documents.count ?? 0,
                    dishname: dishname,
                    categoryName: categoryName
                )
            }
    }
    
    func loadRatingsCount(dishName: String, in categoryName: String) {
        Firestore
            .firestore()
            .collection("Restaurants")
            .document("AfroRestaurant")
            .collection("Ratings")
            .whereField("dishName", isEqualTo: dishName)
            .whereField("categoryName", isEqualTo: categoryName)
            .getDocuments { [weak self] querySnapshot, error in
                guard
                    let self = self,
                    error == nil,
                    let querySnapshot = querySnapshot
                else {
                    self?.sendUpdateNotification(ratingsAverage: 0, dishname: dishName, categoryName: categoryName)
                    return
                }
                
                var rating = 0.0
                var count = 0
                
                for category in querySnapshot.documents {
                    let data = category.data()
                    
                    guard
                        let dishRating = data["rating"] as? Double
                    else { break }
                    
                    if dishRating > 0 {
                        rating += dishRating
                        count += 1
                    }
                }
                
                if rating > 0.0 {
                    self.sendUpdateNotification(
                        ratingsAverage: rating / Double(count),
                        dishname: dishName,
                        categoryName: categoryName
                    )
                } else {
                    self.sendUpdateNotification(
                        ratingsAverage: 0,
                        dishname: dishName,
                        categoryName: categoryName
                    )
                }
            }
    }
    
    func loadRestaurantRatingsAverage() {
        Firestore
            .firestore()
            .collection("Restaurants")
            .document("AfroRestaurant")
            .collection("Ratings")
            .getDocuments { [weak self] querySnapshot, error in
                guard
                    let self = self,
                    error == nil,
                    let querySnapshot = querySnapshot
                else {
                    self?.sendUpdateNotification(restaurantRatings: 0.0)
                    return
                }
                
                var rating = 0.0
                var count = 0
                
                for category in querySnapshot.documents {
                    let data = category.data()
                    
                    guard
                        let dishRating = data["rating"] as? Double
                    else { break }
                    
                    if rating > 0 {
                        rating += dishRating
                        count += 1
                    }
                }
                
                if rating > 0.0 {
                    self.sendUpdateNotification(restaurantRatings: rating / Double (count))
                }
            }
    }
    
    private func deleteQueryForNewUpdate(
        collectionName: String,
        dishName: String,
        category: String,
        completion: @escaping () -> Void) {
        let database = Firestore.firestore()
        let queriedCollection = database
            .collection("Restaurants")
            .document("AfroRestaurant")
            .collection(collectionName)
            .whereField("dishName", isEqualTo: dishName)
            .whereField("categoryName", isEqualTo: category)
        
        queriedCollection.getDocuments { [weak self] (querySnapShot, error) in
            defer { completion() }
            guard error == nil,
                  let querySnapShot = querySnapShot else { return }
            if !querySnapShot.documents.isEmpty {
                self?.deleteSavedDocuments(documents: querySnapShot.documents)
            }
        }
    }
    
    private func deleteSavedDocuments(documents: [QueryDocumentSnapshot]?) {
        guard let documents = documents else { return }
        for document in documents {
            document.reference.delete()
        }
    }
    
    func loadAllUpdates() {
        Firestore
            .firestore()
            .collection("Restaurants")
            .document("AfroRestaurant")
            .collection("Updates")
            .getDocuments { [weak self] querySnapshot, error in
                guard
                    let self = self,
                    error == nil,
                    let querySnapshot = querySnapshot
                else {
                    self?.sendUpdateNotification(updates: [])
                    return
                }
                
                var updates = [UpdateModel]()
                
                
                for category in querySnapshot.documents {
                    let data = category.data()
                    
                    let typeString = data["updateType"] as? String ?? ""
                    guard let type = UpdateType(rawValue: typeString) else { break }
                    let timeInterval: Double = data["dateAdded"] as? Double ?? Date().timeIntervalSince1970
                    updates.append(.init(
                        rating: data["rating"] as? Double ?? 0,
                        dishname: data["dishName"] as? String ?? "a dish",
                        type: type,
                        userName: data["userName"] as? String ?? "a user",
                        date: Date(timeIntervalSince1970: timeInterval)
                    ))
                }
                
                self.sendUpdateNotification(updates: updates)
            }
    }
    
}

extension AdminAnalyticsDataBaseService: AdminAnalyticsDataBaseServiceProtocol {
  
    func updateOrderStatus(status: OrderStatus, orderNumber: String) {
        let document = getOrderDocument(for: orderNumber)
        
        document
            .setData([
                "type" : status.rawValue,
            ], merge: true)
        loadOrders()
    }
    
    
    func createOrder(model: OrderCreateModel) {
        let orderNumber = model.date.timeIntervalSince1970.toString()
        let document = getOrderDocument(for: orderNumber)
        
        document
            .setData([
                "userName" : model.userDetails.userName,
                "address" : model.userDetails.address,
                "phoneNumber" : model.userDetails.phoneNumber,
                "email" : email,
                "date" : model.date.timeIntervalSince1970,
                "type" : model.type.rawValue,
                "orderNumber" : orderNumber,
                "userID": userID
            ], merge: true)
        
        for dishModel in model.dishModels {
            document
                .collection("Dishes")
                .document(dishModel.dishName)
                .setData([
                    "dishName" : dishModel.dishName,
                    "price" : dishModel.price,
                    "quantity" : dishModel.quantity
                ], merge: true)
        }
    }
    
    func loadOrders() {
        Firestore
            .firestore()
            .collection("Restaurants")
            .document("AfroRestaurant")
            .collection("Orders")
            .getDocuments { [weak self] querySnapshot, error in
                guard
                    let self = self,
                    error == nil,
                    let querySnapshot = querySnapshot
                else {
                    self?.sendUpdateNotification(orderModels: [])
                    return
                }
                
                self.generateOrderModels(from: querySnapshot.documents)
            }
    }
    
    func loadOrdersForCurrentUser() {
        Firestore
            .firestore()
            .collection("Restaurants")
            .document("AfroRestaurant")
            .collection("Orders")
            .whereField("userID", isEqualTo: userID)
            .getDocuments { [weak self] querySnapshot, error in
                guard
                    let self = self,
                    error == nil,
                    let querySnapshot = querySnapshot
                else {
                    self?.sendUpdateNotification(orderModels: [])
                    return
                }
                self.generateOrderModels(from: querySnapshot.documents)
            }
    }

    
    private func generateOrderModels(from documents: [QueryDocumentSnapshot]) {
        var orderModels: [OrderModel] = []
        for category in documents {
            let data = category.data()
            
            let type = data["type"] as? String ?? ""
            let timeInterval: Double = data["date"] as? Double ?? Date().timeIntervalSince1970
            
            let orderModel = OrderModel(
                orderNumber: data["orderNumber"] as? String ?? "",
                dishModels: [],
                userDetails: .init(
                    userName: data["userName"] as? String ?? "",
                    address: data["address"] as? String ?? "",
                    phoneNumber: data["phoneNumber"] as? String ?? "",
                    email: data["email"] as? String ?? ""
                ),
                date: Date(timeIntervalSince1970: timeInterval),
                type: OrderStatus(rawValue: type) ?? .delivered,
                userID: data["userID"] as? String ?? self.userID
            )
            
            self.loadDishesModel(for: orderModel.orderNumber, completion: { [weak self, orderModel] disModels in
                let newOrderModel = OrderModel(
                    orderNumber: orderModel.orderNumber,
                    dishModels: disModels,
                    userDetails: orderModel.userDetails,
                    date: orderModel.date,
                    type: orderModel.type,
                    userID: orderModel.userID
                )
                
                orderModels.append(newOrderModel)
                if orderModels.count == documents.count {
                    self?.sendUpdateNotification(orderModels: orderModels)
                }
            })
        }
    }
    
    private func loadDishesModel(for orderNumber: String, completion: @escaping ([DishOrderModel]) -> Void) {
        var dishes: [DishOrderModel] = []
        Firestore
            .firestore()
            .collection("Restaurants")
            .document("AfroRestaurant")
            .collection("Orders")
            .document(orderNumber)
            .collection("Dishes")
            .getDocuments { querySnapshot, error in
                guard
                    error == nil,
                    let querySnapshot = querySnapshot
                else {
                    completion([])
                    return
                }
                
                for category in querySnapshot.documents {
                    let data = category.data()
                    
                    guard
                        let dishName = data["dishName"] as? String,
                        let price = data["price"] as? Double,
                        let quantity = data["quantity"] as? Int
                    else { break }
                    
                    let model = DishOrderModel(
                        dishName: dishName,
                        price: price,
                        quantity: quantity
                    )
                    
                    dishes.append(model)
                }
                completion(dishes)
            }
    }
}
