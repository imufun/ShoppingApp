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
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var cartButton: UIButton!
    
    var productItem: Product? {
        didSet {
            
        }
    }
    
    func setCartButton() {
        cartButton.setTitle("+", for: UIControlState())
        if (self.productItem!.cart) {
            cartButton.setTitle("-", for: UIControlState())
        }
    }
    
    override func configureView() {
        if let product = self.productItem {
            self.productImage.image = product.image
            self.titleLabel.text = product.name
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
        }
        else {
            self.productItem!.cart = true
        }
        self.model.updateProduct(self.productItem)
        self.setCartButton()
    }
    

}
