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
    
    let cart = SingletonManager.cart
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.totalPrice.text = "Total Price $" +  String(format:"%0.2f", cart.totalPrice!)
        self.configureCollectionView()
    }
    
    func configureCollectionView() {
        self.collectionView!.dataSource = self
        self.collectionView!.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.collectionView!.reloadData()
    }
    
    func calcTotalPrice(price: String) {
        
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
        
        let price = model.cart[indexPath!.row].price
        
        // Set up navigation on detail view
        detailView.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
        detailView.navigationItem.leftItemsSupplementBackButton = true
        
        self.calcTotalPrice(price: price!)
    }
    
    // MARK: UICollectionView Data Source
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.cart.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Get an instancer of the prototype Cell we created
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! Cell
        
        // Set the image in the cell
        cell.cellImageView.image = model.cart[indexPath.row].image
        
        // Set the text in the cell
        cell.cellLabel.text = model.cart[indexPath.row].name
        
        //cell.cellPriceLabel.text = model.cart[indexPath.row].price
        
        // Return the cell
        return cell
    }
    
    // MARK: UICollectionView delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    }

}
