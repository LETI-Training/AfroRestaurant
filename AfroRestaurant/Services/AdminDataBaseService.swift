//
//  AdminDataBaseService.swift
//  AfroRestaurant
//
//  Created by Ebubechukwu Dimobi on 12.04.2022.
//  Copyright © 2022 AfroRestaurant. All rights reserved.
//

import Foundation
import FirebaseFirestore
import Firebase

protocol AdminDataBaseServiceProtocol {
    var userName: String { get }
    var email: String { get }
    
    func createNewCategory(categoryModel: AdminCreateCategoryModel)
    func loadCategories(completion: @escaping ([CategoryModel]?) -> ())
    func deleteCategory(categoryModel: CategoryModel, completion: @escaping () -> Void)
    func addDishToCategory(dishModel: AdminCreateDishModel)
}

final class AdminDataBaseService {
    
    let userName: String = {
        Firebase.Auth.auth().currentUser?.email ?? ""
    }()
    
    let email: String = {
        Firebase.Auth.auth().currentUser?.displayName ?? ""
    }()
    
    private func deleteSavedDocuments(documents: [QueryDocumentSnapshot]?) {
        guard let documents = documents else { return }
        for document in documents {
            document.reference.delete()
        }
    }
    
    private func getCategoryDocument(for categoryName: String) -> DocumentReference {
        Firestore
            .firestore()
            .collection("Restaurants")
            .document("AfroRestaurant")
            .collection("Categories")
            .document(categoryName)
    }
}

extension AdminDataBaseService: AdminDataBaseServiceProtocol {
    func addDishToCategory(dishModel: AdminCreateDishModel) {
        let document = getCategoryDocument(for: dishModel.category.categoryName)
        
        document
            .collection("Dishes")
            .document(dishModel.dishName)
            .setData([
                "dishName" : dishModel.dishName,
                "dishDescription" : dishModel.dishDescription,
                "calories" : dishModel.calories,
                "price" : dishModel.price,
                "imageString" : dishModel.imageString ?? ""
            ], merge: true)
    }
    
    func createNewCategory(categoryModel: AdminCreateCategoryModel) {
        let document = getCategoryDocument(for: categoryModel.categoryName)
        document
            .setData([
                "categoryName" : categoryModel.categoryName,
                "categoryDescription" : categoryModel.categoryDescription
            ], merge: true)
    }
    
    func loadCategories(completion: @escaping ([CategoryModel]?) -> ()) {
        
        var categories: [CategoryModel] = []
        
        Firestore
            .firestore()
            .collection("Restaurants")
            .document("AfroRestaurant")
            .collection("Categories")
            .getDocuments { querySnapshot, error in
                guard
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
                        let categoryDescription = data["categoryDescription"] as? String
                    else { break }
                    
                    categories
                        .append(.init(categoryName: categoryName, categoryDescription: categoryDescription, dishes: []))
                }
                completion(categories)
            }
    }
    
    func deleteCategory(categoryModel: CategoryModel, completion: @escaping () -> Void) {
        let database = Firestore.firestore()
        let queriedCollection = database
            .collection("Restaurants")
            .document("AfroRestaurant")
            .collection("Categories")
            .whereField("categoryName", isEqualTo: categoryModel.categoryName)
        
        queriedCollection.getDocuments { [weak self] (querySnapShot, error) in
            defer { completion() }
            guard error == nil,
                  let querySnapShot = querySnapShot else { return }
            if !querySnapShot.documents.isEmpty {
                self?.deleteSavedDocuments(documents: querySnapShot.documents)
            }
        }
    }
}
