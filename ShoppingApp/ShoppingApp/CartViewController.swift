//
//  CartViewController.swift
//  ShoppingApp
//
//  Created by Porcaro, Keano Dean - porkd002 on 11/11/17.
//  Copyright © 2017 Porcaro, Keano Dean - porkd002. All rights reserved.
//

import UIKit

class CartViewController: DetailViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var totalPrice: UILabel!
    
    let model = SingletonManager.model
    
    let cart = SingletonManager.cart // total running price of everything
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.totalPrice.text = "Total Price $" +  String(format:"%0.2f", cart.totalPrice!)
        self.configureCollectionView()
    }
    
    // This method is called when the user presses the back button on the ProductViewController
    // Just incase they remove an item from the cart, the total price will update and refresh on the
    // CartViewController (this)
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.totalPrice.text = "Total Price $" + String(format:"%0.2f", cart.totalPrice!)
    }
    
    func configureCollectionView() {
        self.collectionView!.dataSource = self
        self.collectionView!.delegate = self
    }
    
    
    // Mark: Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Find out what row was selected
        let indexPath = self.collectionView?.indexPath(for: sender as! Cell)
        
        //sender as? NSIndexPath
        
        // Grab the detail view
        let detailView = (segue.destination as! UINavigationController).topViewController as! ProductViewController
        
        // Get the selected cell's image
        let product = model.cart[indexPath!.row]
        
        // Pass the content to the detail view
        detailView.productItem = product
        
        // Set up navigation on detail view
        detailView.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
        detailView.navigationItem.leftItemsSupplementBackButton = true
        
    }
    
    // MARK: UICollectionView Data Source
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.cart.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! Cell
        cell.cellImageView.image = model.cart[indexPath.row].image
        cell.cellLabel.text = model.cart[indexPath.row].name
        return cell
    }
    
    // MARK: UICollectionView delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    }

}
