//
//  MasterViewController.swift
//  ShoppingApp
//
//  Created by Porcaro, Keano Dean - porkd002 on 10/11/17.
//  Copyright © 2017 Porcaro, Keano Dean - porkd002. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {
    
    // segue stuff
    var segueArray = [String]()
    var segueDictionary = Dictionary<String, UIImage>();

    var detailViewController: DetailViewController? = nil
    //var objects = [Any]()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        segueArray.append("Homepage")
        segueArray.append("Products")
        segueArray.append("Search")
        segueArray.append("Cart")
        segueArray.append("Finder")
        segueArray.append("Checkout")
        
        segueDictionary["Homepage"] = UIImage(named: "home")
        segueDictionary["Products"] = UIImage(named: "product")
        segueDictionary["Search"] = UIImage(named: "product")
        segueDictionary["Cart"] = UIImage(named: "product")
        segueDictionary["Finder"] = UIImage(named: "product")
        segueDictionary["Checkout"] = UIImage(named: "product")
        
        
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Find out what row was selected
        if let indexPath = self.tableView.indexPathForSelectedRow {
            
            // Grab the detail view
            let detailView = (segue.destination as! UINavigationController).topViewController as! DetailViewController
            
            // Get the selected cell's text
            let key = segueArray[indexPath.row]
            
            // Get the content to display
            let content = segueDictionary[key]
            
            // Pass the content to the detail view
            detailView.detailItem = content
            
            // Set up navigation on detail view
            detailView.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
            detailView.navigationItem.leftItemsSupplementBackButton = true
        }
        
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return segueArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create a cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        // Get the object to put in the cell
        let text = segueArray[indexPath.row]
        
        // Set the text in the cell
        cell.textLabel!.text = text
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }


}

