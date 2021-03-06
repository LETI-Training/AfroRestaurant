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
    func loadDishes(for categoryName: String, completion: @escaping ([DishModel]?) -> Void)
    func loadDish(dishName: String, for categoryName: String, completion: @escaping (DishModel?) -> Void)
    func deleteDish(_ dishName: String, in categoryName: String, completion: @escaping () -> Void)
    func updateDishToCategory(dishModel: AdminCreateDishModel)
    func getDishModel(dishName: String, categoryName: String) -> DishModel?
}

final class AdminDataBaseService {
    
    let lock = NSRecursiveLock()
    
    private var dishesContainer = [String: [DishModel]]()
    private var categories = [CategoryModel]()
    var categoriesLoadCompletion: ((([CategoryModel])?) -> Void)?
    
    let userName: String = {
        Firebase.Auth.auth().currentUser?.displayName ?? ""
    }()
    
    let email: String = {
        Firebase.Auth.auth().currentUser?.email ?? ""
    }()
    
    init() {
        loadCategoriesFromDataBase { _ in }
        addListner()
    }
    
    private func addListner() {
        Firestore
            .firestore()
            .collection("Restaurants")
            .document("AfroRestaurant")
            .collection("Categories")
            .addSnapshotListener { [weak self] _, _ in
                self?.loadCategoriesFromDataBase { _ in }
            }
    }
    
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
    
    private func updateDishes(dishesModels: [DishModel], categoryName: String) {
        lock.lock()
        defer { lock.unlock() }
        dishesContainer.updateValue(dishesModels, forKey: categoryName)
        categoriesLoadCompletion?(getCategories())
    }
    
    private func updateCategories(categories: [CategoryModel]) {
        lock.lock()
        defer { lock.unlock() }
        self.categories = categories
    }
    
    private func getCategories() -> [CategoryModel] {
        lock.lock()
        defer { lock.unlock() }
        
        return categories.map {
            CategoryModel(
                categoryName: $0.categoryName,
                categoryDescription: $0.categoryDescription,
                dishes: dishesContainer[$0.categoryName] ?? []
            )
        }
    }
    
    private func deleteCategoryLocally(categoryName: String) {
        lock.lock()
        defer { lock.unlock() }
        categories.removeAll(where: { $0.categoryName == categoryName })
        dishesContainer.removeValue(forKey: categoryName)
    }
    
    private func deleteDishLocally(categoryName: String) {
        lock.lock()
        defer { lock.unlock() }
        dishesContainer.removeValue(forKey: categoryName)
    }
    
    private func createCategoryLocally(category: AdminCreateCategoryModel) {
        lock.lock()
        defer { lock.unlock() }
        categories.append(
            .init(
                categoryName: category.categoryName,
                categoryDescription: category.categoryDescription,
                dishes: []
            )
        )
    }
}

extension AdminDataBaseService: AdminDataBaseServiceProtocol {
    func updateDishToCategory(dishModel: AdminCreateDishModel) {
        addDishToCategory(dishModel: dishModel)
    }
    
    func addDishToCategory(dishModel: AdminCreateDishModel) {
        let document = getCategoryDocument(for: dishModel.category.categoryName)
        
        document
            .collection("Dishes")
            .document(dishModel.dishName)
            .setData([
                "dishName" : dishModel.dishName,
                "categoryName": dishModel.category.categoryName,
                "dishDescription" : dishModel.dishDescription,
                "calories" : dishModel.calories,
                "price" : dishModel.price,
                "imageString" : dishModel.imageString
            ], merge: true)
        
        loadDishes(for: dishModel.category.categoryName) { _ in }
    }
    
    func createNewCategory(categoryModel: AdminCreateCategoryModel) {
        let document = getCategoryDocument(for: categoryModel.categoryName)
        document
            .setData([
                "categoryName" : categoryModel.categoryName,
                "categoryDescription" : categoryModel.categoryDescription
            ], merge: true)
        createCategoryLocally(category: categoryModel)
        loadCategoriesFromDataBase { _ in }
    }
    
    private func loadCategoriesFromDataBase(completion: @escaping ([CategoryModel]?) -> ()) {
        var categories: [CategoryModel] = []
        
        Firestore
            .firestore()
            .collection("Restaurants")
            .document("AfroRestaurant")
            .collection("Categories")
            .getDocuments { [weak self] querySnapshot, error in
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
                    self?.loadDishes(for: categoryName, completion: { _ in })
                }
                completion(categories)
                self?.updateCategories(categories: categories)
            }
    }
    
    func loadCategories(completion: @escaping ([CategoryModel]?) -> ()) {
        loadCategoriesFromDataBase { _ in }
        lock.lock()
        defer { lock.unlock() }
        guard
            categories.isEmpty,
            dishesContainer.isEmpty
        else {
            completion(getCategories())
            return
        }
        self.categoriesLoadCompletion = completion
        loadCategoriesFromDataBase(completion: completion)
    }
    
    func loadDishes(for categoryName: String, completion: @escaping ([DishModel]?) -> Void) {
        var dishes: [DishModel] = []
        Firestore
            .firestore()
            .collection("Restaurants")
            .document("AfroRestaurant")
            .collection("Categories")
            .document(categoryName)
            .collection("Dishes")
            .getDocuments { [weak self] querySnapshot, error in
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
                        let dishName = data["dishName"] as? String,
                        let dishDescription = data["dishDescription"] as? String,
                        let calories = data["calories"] as? Int,
                        let price = data["price"] as? Double,
                        let imageString = data["imageString"] as? String,
                        let categoryNAme = data["categoryName"] as? String
                    else { break }
                    
                    dishes.append(DishModel(
                        dishName: dishName,
                        categoryName: categoryNAme,
                        dishDescription: dishDescription,
                        calories: calories,
                        price: price,
                        imageString: imageString,
                        rating: data["rating"] as? Double,
                        favoritesCount: data["favoritesCount"] as? Int,
                        profitsMade: data["profitsMade"] as? Double)
                    )
                }
                completion(dishes)
                self?.updateDishes(dishesModels: dishes, categoryName: categoryName)
            }
    }
    
    func loadDish(dishName: String, for categoryName: String, completion: @escaping (DishModel?) -> Void) {
        loadDishes(for: categoryName) { dishModels in
            completion(dishModels?.first(where: { $0.dishName == dishName }))
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
                self?.deleteCategoryLocally(categoryName: categoryModel.categoryName)
                self?.loadCategoriesFromDataBase { _ in }
            }
        }
    }
    
    func deleteDish(_ dishName: String, in categoryName: String, completion: @escaping () -> Void) {
        let document = getCategoryDocument(for: categoryName)
        
        let queriedCollection = document
            .collection("Dishes")
            .whereField("dishName", isEqualTo: dishName)
        
        queriedCollection.getDocuments { [weak self] (querySnapShot, error) in
            defer { completion() }
            guard error == nil,
                  let querySnapShot = querySnapShot else { return }
            if !querySnapShot.documents.isEmpty {
                self?.deleteSavedDocuments(documents: querySnapShot.documents)
                self?.deleteDishLocally(categoryName: categoryName)
                self?.loadCategories { _ in }
            }
        }
    }
    
    func getDishModel(dishName: String, categoryName: String) -> DishModel? {
        lock.lock()
        defer { lock.unlock() }
        
        let dishes = dishesContainer[categoryName]
        return dishes?.first(where: { $0.dishName == dishName})
    }
}
