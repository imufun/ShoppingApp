//
//  DetailViewController.swift
//  ShoppingApp
//
//  Created by Porcaro, Keano Dean - porkd002 on 10/11/17.
//  Copyright © 2017 Porcaro, Keano Dean - porkd002. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    /* Description of the item */
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    
    /* The referenced image view form the storyboard */
    @IBOutlet weak var imageView: UIImageView!
    
    /* Update the view */
    var detailItem: UIImage? {
        didSet {
            self.configureView()
        }
    }
    
    /*  Update the user interface for the detail item. */
    func configureView() {
        if let detail = self.detailItem {
            if let label = self.detailDescriptionLabel {
                label.text = detail.description
                imageView.image = detail
            }
        }
    }

    /* Inherited function */
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    /* Inherited function */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

