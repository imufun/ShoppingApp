//
//  ProductViewController.swift
//  ShoppingApp
//
//  Created by Porcaro, Keano Dean - porkd002 on 11/11/17.
//  Copyright © 2017 Porcaro, Keano Dean - porkd002. All rights reserved.
//

import UIKit

class ProductViewController: DetailViewController {
    
    let model = SingletonManager.model
    
    let cart = SingletonManager.cart
    
    @IBOutlet weak var productImage: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var cartButton: UIButton!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var productItem: Product? {
        didSet {
            
        }
    }
    
    func setCartButton() {
        cartButton.setTitle("Add to cart (+)", for: UIControlState())
        if (self.productItem!.cart) {
            cartButton.setTitle("Remove from cart (-)", for: UIControlState())
        }
    }
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
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
