//
//  Model.swift
//  ShoppingApp
//
//  Created by Porcaro, Keano Dean - porkd002 on 10/11/17.
//  Copyright © 2017 Porcaro, Keano Dean - porkd002. All rights reserved.
//

import UIKit

class Model {
    var segueArray = [String]()
    var segueDictionary = Dictionary<String, UIImage>();
    
    var products = [UIImage]()
    
    //static let sharedModel = Model()
    
    init() {
        segueArray.append("Homepage")
        segueArray.append("Products")
        segueArray.append("Search")
        segueArray.append("Cart")
        segueArray.append("Finder")
        segueArray.append("Checkout")
        
        segueDictionary["Homepage"] = UIImage(named: "home")
        segueDictionary["Products"] = UIImage(named: "product")
        segueDictionary["Search"] = UIImage(named: "find")
        segueDictionary["Cart"] = UIImage(named: "cart")
        segueDictionary["Finder"] = UIImage(named: "map")
        segueDictionary["Checkout"] = UIImage(named: "checkout")
        
        products.append(UIImage(named: "product")!)
    }

}
