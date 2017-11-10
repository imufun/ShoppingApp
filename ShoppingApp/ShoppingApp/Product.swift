//
//  Product.swift
//  ShoppingApp
//
//  Created by Porcaro, Keano Dean - porkd002 on 11/11/17.
//  Copyright © 2017 Porcaro, Keano Dean - porkd002. All rights reserved.
//

import UIKit

class Product: NSObject {
    var image: UIImage?
    var price: String?
    var category: String?
    var details: String! = ""
    var name: String! = ""
    var cart = false
    var uid: String!
    
    override init() {
    }
    
    init(uid: String, name: String, details: String, image: UIImage, cart: Bool, price: String, category: String) {
        self.uid = uid
        self.name = name
        self.details = details
        self.image = image
        self.cart = cart
        self.price = price
        self.category = category
    }
    
    init(uid: String, name: String, details: String) {
        self.uid = uid
        self.name = name
        self.details = details
        self.cart = false
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if let otherProduct = object as? Product {
            if self.uid == otherProduct.uid && self.name == otherProduct.name && self.image!.isEqual(otherProduct.image) {
                return true
            }
            else {
                return false
            }
        }
        else {
            return false
        }
    }
}
