//
//  Models.swift
//  AfroRestaurant
//
//  Created by Ebubechukwu Dimobi on 12.04.2022.
//  Copyright © 2022 AfroRestaurant. All rights reserved.
//


struct AdminCreateCategoryModel {
    let categoryName: String
    let categoryDescription: String
}

struct AdminCreateDishModel {
    let category: AdminCreateCategoryModel
    let dishName: String
    let dishDescription: String
    let calories: Int
    let price: Double
    let imageString: String
}

struct CategoryModel: Hashable {
    let categoryName: String
    let categoryDescription: String
    let dishes: [DishModel]
}

struct DishModel: Hashable {
    let dishName: String
    let dishDescription: String
    let calories: Int
    let price: Double
    let imageString: String
    let rating: Double?
    let favoritesCount: Int?
    let profitsMade: Double?
}

struct CartModel: Hashable {
    let dishModel: DishModel
    let quantity: Int
}
