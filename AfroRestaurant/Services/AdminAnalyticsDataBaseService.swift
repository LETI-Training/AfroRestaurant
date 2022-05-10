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
}

protocol AdminAnalyticsDataBaseServiceOutput: AnyObject {
    func adminService(didFinishLoading orderModels: [AdminAnalyticsDataBaseService.OrderModel])
}

final class AdminAnalyticsDataBaseService {
    private var outputs: [WeakRefeferenceWrapper<AdminAnalyticsDataBaseServiceOutput>] = []
    private let updateLock = NSRecursiveLock()
    
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
