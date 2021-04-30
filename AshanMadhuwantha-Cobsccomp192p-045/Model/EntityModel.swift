//
//  EntityModel.swift
//  AshanMadhuwantha-Cobsccomp192p-045
//
//  Created by Ashan Madhuwantha on 2021-04-29.
//

import Foundation

struct User {
    
    var userName: String
    var userEmail: String
    var userPassword: String
    var userPhone: String
    
}

struct FoodItem {
    
    var foodName: String
    var foodId: String
    var foodDescription: String
    var foodPrice: Double
    var discount: Int
    var foodImgRes: String
    var foodCategory: String
    var availability: Bool
    
}

struct Category {
    
    var categoryName: String
    var categoryID: String
    
    }
struct Order {
    var orderID: String
    var cust_email: String
    var cust_name: String
    var date: Double
    var status_code: Int
    var orderItems: [OrderItem] = []
}

struct OrderItem {
    var item_name: String
    var price: Double
}
