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
    
    func createNewCategory(categoryModel: AdminCategoryModel)
    func loadCategories(completion: @escaping ([AdminCategoryModel]?) -> ())
    func deleteCategory(categoryModel: AdminCategoryModel, completion: @escaping () -> Void)
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
}

extension AdminDataBaseService: AdminDataBaseServiceProtocol {
    func createNewCategory(categoryModel: AdminCategoryModel) {
        Firestore
            .firestore()
            .collection("Restaurants")
            .document("AfroRestaurant")
            .collection("Categories")
            .document()
            .setData([
                "categoryName" : categoryModel.categoryName,
                "categoryDescription" : categoryModel.categoryDescription
            ], merge: true)
    }
    
    func loadCategories(completion: @escaping ([AdminCategoryModel]?) -> ()) {
        
        var categories: [AdminCategoryModel] = [AdminCategoryModel]()
        
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
                        .append(.init(categoryName: categoryName, categoryDescription: categoryDescription))
                }
                completion(categories)
            }
    }
    
    func deleteCategory(categoryModel: AdminCategoryModel, completion: @escaping () -> Void) {
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
