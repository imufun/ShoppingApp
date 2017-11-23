//
//  Model.swift
//  ShoppingApp
//
//  Created by Porcaro, Keano Dean - porkd002 on 10/11/17.
//  Copyright © 2017 Porcaro, Keano Dean - porkd002. All rights reserved.
//

import UIKit
import CoreData

/* The main class that deals with data */
class Model {
    var segueArray = [String]()
    var segueDictionary = Dictionary<String, UIImage>();
    
    var products = [Product]()
    var storedProducts = [NSManagedObject]()
    
    //static let sharedModel = Model()
    
    /* Set the variables in the array and ditionary for segue's */
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
        
        self.refreshProducts()
        
        self.loadProducts()
        
    }
    
    /* Cart function */
    var cart: [Product] {
        get {
            var selectedProducts = [Product]()
            
            if (products.count > 0)
            {
                for count in 0...products.count - 1
                {
                    if products[count].cart
                    {
                        selectedProducts.append(products[count])
                    }
                }
            }
            
            return selectedProducts
        }
    }
    
    /* Grab the produts from the website in JSON format */
    func refreshProducts()
    {
        let url = NSURL(string: "http://partiklezoo.com/3dprinting/")
        let config = URLSessionConfiguration.default
        config.isDiscretionary = true
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: url! as URL, completionHandler:
            {(data, response, error) in
                do {
                    let json = try JSON(data: data!)
                    
                    for count in 0...json.count - 1
                    {
                        let newProduct = Product()
                        newProduct.name = json[count]["name"].string
                        newProduct.price = json[count]["price"].string
                        newProduct.details = json[count]["description"].string
                        newProduct.category = json[count]["category"].string
                        newProduct.uid = json[count]["uid"].string
                        let imgURL = json[count]["image"].string!
                        //print(json[count]["image"].string)
                        
                        self.addItemToProducts(newProduct, imageURL: imgURL)
                    }
                }
                catch let error as NSError
                {
                    print("Could not convert. \(error), \(error.userInfo)")
                }
                
        })
        task.resume()
    }
    
    /* Load the products into the view */
    func loadProducts() {
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Products")
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            
            storedProducts = results as! [NSManagedObject]
            if (storedProducts.count > 0)
            {
                for index in 0 ... storedProducts.count - 1
                {
                    let binaryData = storedProducts[index].value(forKey: "image") as! Data
                    
                    let image = UIImage(data: binaryData)
                    let details = storedProducts[index].value(forKey: "details") as! String
                    //print(details)
                    let name = storedProducts[index].value(forKey: "name") as! String
                    //print(name)
                    let uid = storedProducts[index].value(forKey: "uid") as! String
                    //print(uid)
                    let price = storedProducts[index].value(forKey: "price") as! String
                    //print(price)
                    let category = storedProducts[index].value(forKey: "category") as! String
                    //print(category)
                    let cart = storedProducts[index].value(forKey: "cart") as! Bool
                    
                    let loadedProduct = Product(uid: uid, name: name, details: details, image: image!, cart: cart, price: price, category: category);
                    
                    products.append(loadedProduct)
                }
            }
        }
        catch let error as NSError
        {
            print("Could not load. \(error), \(error.userInfo)")
        }
    }
    
    /* Check if the product exists (UID) */
    func checkForProduct(_ searchItem: Product) -> Int {
        var targetIndex = -1
        
        if (products.count > 0) {
            for index in 0 ... products.count - 1 {
                if (products[index].uid.isEqual(searchItem.uid)) {
                    targetIndex = index
                }
            }
        }
        
        return targetIndex
    }
    
    /* Add the JSON product to the view to be parsed */
    func addItemToProducts(_ newProduct: Product!, imageURL: String) {
        if (checkForProduct(newProduct) == -1)
        {
            let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            let picture = UIImageJPEGRepresentation(loadImage(imageURL), 1)
            
            let entity =  NSEntityDescription.entity(forEntityName: "Products", in:managedContext)
            
            let productToAdd = NSManagedObject(entity: entity!, insertInto: managedContext)
            
            productToAdd.setValue(picture, forKey: "image")
            productToAdd.setValue(newProduct.name, forKey: "name")
            productToAdd.setValue(newProduct.details, forKey: "details")
            productToAdd.setValue(newProduct.uid, forKey: "uid")
            productToAdd.setValue(newProduct.cart, forKey: "cart")
            productToAdd.setValue(newProduct.price, forKey: "price")
            productToAdd.setValue(newProduct.category, forKey: "category")
            
            do
            {
                try managedContext.save()
            }
            catch let error as NSError
            {
                print("Could not save. \(error), \(error.userInfo)")
            }
            
            storedProducts.append(productToAdd)
            products.append(newProduct)
        }
    }
    
    /* Load the image for the product */
    func loadImage(_ imageURL: String) -> UIImage
    {
        
        var image: UIImage!
        
        if let url = NSURL(string: imageURL) {
            if let data = NSData(contentsOf: url as URL){
                image = UIImage(data: data as Data)
            }
        }
        
        return image!
    }
    
    /* Update the products details if something changes */
    func updateProduct(_ newProduct: Product!) {
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Products")
        fetchRequest.predicate = NSPredicate(format: "uid = %@", newProduct.uid)
        
        do {
            if let fetchResults = try managedContext.fetch(fetchRequest) as? [NSManagedObject] {
                
                if fetchResults.count != 0 {
                    
                    let managedObject = fetchResults[0]
                    
                    managedObject.setValue(newProduct.details, forKey: "details")
                    do
                    {
                        try managedContext.save()
                    }
                    catch let error as NSError
                    {
                        print("Could not save. \(error), \(error.userInfo)")
                    }
                }
            }
        }
        catch let error as NSError
        {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    

}
