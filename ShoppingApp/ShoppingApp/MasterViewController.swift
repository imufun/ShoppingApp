//
//  MasterViewController.swift
//  ShoppingApp
//
//  Created by Porcaro, Keano Dean - porkd002 on 10/11/17.
//  Copyright © 2017 Porcaro, Keano Dean - porkd002. All rights reserved.
//

import UIKit
import CoreData

class MasterViewController: UITableViewController {
    

    var detailViewController: DetailViewController? = nil
    var managedObjectContext: NSManagedObjectContext? = nil
    
    let model = SingletonManager.model
    
    /* inherited function */
    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.current.userInterfaceIdiom == .pad {
            self.clearsSelectionOnViewWillAppear = false
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
    }

    /* inherited function */
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        

        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    /* inherited function */
    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    /* inherited function */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: - Segues

    /* Set the segues for the ModelViewController */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Find out what row was selected
        if let indexPath = self.tableView.indexPathForSelectedRow {
            
            // Grab the detail view
            let detailView = (segue.destination as! UINavigationController).topViewController as! DetailViewController
            
            // Get the selected cell's text
            let key = model.segueArray[indexPath.row]
            
            // Get the content to display
            let content = model.segueDictionary[key]
            
            // Pass the content to the detail view
            detailView.detailItem = content
            
            // Set up navigation on detail view
            detailView.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
            detailView.navigationItem.leftItemsSupplementBackButton = true
        }
        
    }

    // MARK: - Table View
    
    /* Returns the number of sections (1) */
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    /* Set the amount of segues based on the array's count */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.segueArray.count
    }

    /* Set the cell and update the details inside the cell
     * Since this class is the master class, it doesn't need to put anything important inside except for
     * template data
     */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create a cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        // Get the object to put in the cell
        let text = model.segueArray[indexPath.row]
        
        // Set the text in the cell
        cell.textLabel!.text = text
        
        cell.imageView!.image = model.segueDictionary[text];
        return cell
    }

    /* Return false if you do not want the specified item to be editable. */
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    /* Set up the segue */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: model.segueArray[indexPath.row], sender: model)
    }
    


}

