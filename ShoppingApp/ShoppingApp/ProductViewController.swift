//
//  ProductViewController.swift
//  ShoppingApp
//
//  Created by Porcaro, Keano Dean - porkd002 on 11/11/17.
//  Copyright © 2017 Porcaro, Keano Dean - porkd002. All rights reserved.
//

import UIKit

/* Displays details on the inidivual product selected by the user when they tap a cell in the ProductsViewController */
class ProductViewController: DetailViewController {
    
    let model = SingletonManager.model
    
    let cart = SingletonManager.cart
    
    @IBOutlet weak var productImage: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var cartButton: UIButton!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    /* Variable */
    var productItem: Product? {
        didSet {
            
        }
    }
    
    /* Update the cart button if the item is in or not atm */
    func setCartButton() {
        cartButton.setTitle("Add to cart (+)", for: UIControlState())
        if (self.productItem!.cart) {
            cartButton.setTitle("Remove from cart (-)", for: UIControlState())
        }
    }
    
    /* Configure the view to have the details of the product */
    override func configureView() {
        if let product = self.productItem {
            self.productImage.image = product.image
            self.titleLabel.text = "Item name:\n" + product.name
            if let cabel = self.priceLabel {
                cabel.text = "Price:\n$" + product.price
            }
            if let label = self.descriptionLabel {
                label.text = "Description:\n" + product.details
            }
            self.setCartButton()
        }
    }
    
    /* On view update the class */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    /* Inherited function */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /* If the user selects a item and puts it in their cart, update the total price */
    @IBAction func cartSelected(_ sender: AnyObject) {
        if (self.productItem!.cart) {
            self.productItem!.cart = false
            cart.totalPrice = cart.totalPrice! - Double((productItem?.price)!)!
        }
        else {
            cart.totalPrice = cart.totalPrice! + Double((productItem?.price)!)!
            self.productItem!.cart = true
        }
        self.model.updateProduct(self.productItem)
        self.setCartButton()
    }
    

}
