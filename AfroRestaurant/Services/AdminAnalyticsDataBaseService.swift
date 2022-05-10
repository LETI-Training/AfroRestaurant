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
    }
    
    struct DishOrderModel {
        let dishName: String
        let price: Double
        let quantity: Int
    }
    
    enum OrderStatus: String, Codable {
        case delivered
        case cancelled
        case created
    }
}


protocol AdminAnalyticsDataBaseServiceProtocol {
    func addListner(_ listener: AdminAnalyticsDataBaseServiceOutput)
    func removeListner(_ listener: AdminAnalyticsDataBaseServiceOutput)
    func createOrder(model: AdminAnalyticsDataBaseService.OrderCreateModel)
}

protocol AdminAnalyticsDataBaseServiceOutput: AnyObject {
    func adminService(didFinishLoading orderModels: [AdminAnalyticsDataBaseService.OrderModel])
}

final class AdminAnalyticsDataBaseService {
    private var outputs: [WeakRefeferenceWrapper<AdminAnalyticsDataBaseServiceOutput>] = []
    private let updateLock = NSRecursiveLock()
    
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
        updateLock.lock()
        defer { updateLock.unlock() }
        
        outputs.forEach {
            $0.object?.adminService(didFinishLoading: orderModels)
        }
    }
}

extension AdminAnalyticsDataBaseService: AdminAnalyticsDataBaseServiceProtocol {
    
    func createOrder(model: OrderCreateModel) {
        let orderNumber = model.date.timeIntervalSince1970.toString()
        let document = getOrderDocument(for: orderNumber)
        
        document
            .setData([
                "userName" : model.userDetails.userName,
                "address" : model.userDetails.address,
                "phoneNumber" : model.userDetails.phoneNumber,
                "email" : model.userDetails.email,
                "date" : model.date,
                "type" : model.type,
                "orderNumber" : orderNumber
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
    
    private func loadOrders() {
        var orderModels: [OrderModel] = []
        
        Firestore
            .firestore()
            .collection("Restaurants")
            .document("AfroRestaurant")
            .collection("Orders")
            .getDocuments { [weak self] querySnapshot, error in
                guard
                    error == nil,
                    let querySnapshot = querySnapshot
                else {
                    self?.sendUpdateNotification(orderModels: [])
                    return
                }
                
                for category in querySnapshot.documents {
                    let data = category.data()
                    
                    let orderModel = OrderModel(
                        orderNumber: data["orderNumber"] as? String ?? "",
                        dishModels: [],
                        userDetails: .init(
                            userName: data["userName"] as? String ?? "",
                            address: data["address"] as? String ?? "",
                            phoneNumber: data["phoneNumber"] as? String ?? "",
                            email: data["email"] as? String ?? ""
                        ),
                        date: data["date"] as? Date ?? Date(),
                        type: data["type"] as? OrderStatus ?? .delivered
                    )
                    
                    self?.loadDishesModel(for: orderModel.orderNumber, completion: { [weak self, orderModel] disModels in
                        let newOrderModel = OrderModel(
                            orderNumber: orderModel.orderNumber,
                            dishModels: disModels,
                            userDetails: orderModel.userDetails,
                            date: orderModel.date,
                            type: orderModel.type
                        )
                        
                        orderModels.append(newOrderModel)
                        self?.sendUpdateNotification(orderModels: orderModels)
                    })
                }
            }
    }
    
    func loadDishesModel(for orderNumber: String, completion: @escaping ([DishOrderModel]) -> Void) {
        var dishes: [DishOrderModel] = []
        Firestore
            .firestore()
            .collection("Restaurants")
            .document("AfroRestaurant")
            .collection("Categories")
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
