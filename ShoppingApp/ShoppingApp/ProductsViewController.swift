//
//  ProductsViewController.swift
//  ShoppingApp
//
//  Created by Porcaro, Keano Dean - porkd002 on 10/11/17.
//  Copyright © 2017 Porcaro, Keano Dean - porkd002. All rights reserved.
//

import UIKit

/* ProductsViewController - All the products displayed nicely in a CollectionView */
class ProductsViewController: DetailViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let model = SingletonManager.model
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var addToCartButton: UIView!
    
    /* Call the configureCollectionView() to set up the view when the page loads */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCollectionView()
    }
    
    /* Set the source and delegate for the collection view to be itself */
    func configureCollectionView() {
        self.collectionView!.dataSource = self
        self.collectionView!.delegate = self
    }
    
    /* Prepare the segue with update details */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Find out what row was selected
        let indexPath = self.collectionView?.indexPath(for: sender as! Cell)
        
        //sender as? NSIndexPath
        
        // Grab the detail view
        let detailView = (segue.destination as! UINavigationController).topViewController as! ProductViewController
        
        // Get the selected cell's image
        let product = model.products[indexPath!.row]
        
        // Pass the content to the detail view
        detailView.productItem = product
        
        // Set up navigation on detail view
        detailView.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
        detailView.navigationItem.leftItemsSupplementBackButton = true
        
        
    }
    
    // MARK: UICollectionViewDataSource
    
    /* return 1 */
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    /* Return the amount of products displayed in this class */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.products.count
    }
    
    /* Set the cell details based on the poduct input */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! Cell
        cell.cellImageView.image = model.products[indexPath.row].image
        cell.cellLabel.text = model.products[indexPath.row].name
        if let label = cell.cellPriceLabel {
            label.text = "$" + model.products[indexPath.row].price
        }
        return cell
    }
    
    // MARK: UICollectionViewDelegate

    /* These do nothing but they need to be here cause of inheritance */
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
    
    // MARK: addItemToCart
    
    /* IGNORE: Does nothing */
    @IBAction func addItemToCart(_ sender: Any) {
        //model.addItemToCart(model.)
    }
    
}
