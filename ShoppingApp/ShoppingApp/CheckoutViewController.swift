//
//  CheckoutViewController.swift
//  ShoppingApp
//
//  Created by Porcaro, Keano Dean - porkd002 on 12/11/17.
//  Copyright © 2017 Porcaro, Keano Dean - porkd002. All rights reserved.
//

import UIKit
import CoreData
import Foundation

// TODO: Make items go into cart more than once
class CheckoutViewController: DetailViewController {

    let model = SingletonManager.model
    let cart = SingletonManager.cart
    
    // UI items
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var cardNameText: UITextField!
    @IBOutlet weak var cardNumberText: UITextField!
    @IBOutlet weak var cardExpiryText: UITextField!
    @IBOutlet weak var cardCSVText: UITextField!
    @IBOutlet weak var purchaseButton: UIButton!
    @IBOutlet weak var absButton: UIButton!
    @IBOutlet weak var paintingButton: UIButton!
    
    // Other variables
    var abs: Bool = false;
    var painting: Bool = false;
    var material: String = "pla";
    var isPainting: String = "false";
    var ogCartPrice: Double = 0.0;
    var printingPrice: Double = 0.0;
    var absPrice: Double = 0.0;
    var bothPrices: Double = 0.0;
    
    
    // We have to make a purchase using
    // http://partiklezoo.com/3dprinting/?action=purchase&u0001=2&total=120&material=pla&painting=false
    // Either POST or GET

    override func configureView() {
        ogCartPrice = cart.totalPrice!;
        if let label = self.totalPrice {
            label.text = "$" + String(format:"%0.2f", cart.totalPrice!)
        }
        
        // take cart value, get printing and abs price then if true append later
        // saves us time and stupid calculations
        printingPrice = ogCartPrice + (ogCartPrice * 0.55);
        absPrice = ogCartPrice + (ogCartPrice * 0.1);
        bothPrices = ogCartPrice + (ogCartPrice * 0.1) + (ogCartPrice * 0.55);
        
    }
    
    // thanks stackoverflow xx
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CheckoutViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Check Input
    
    // This function checks if everything is filled out
    // TODO: Just make it one if statement, it's not that hard
    @IBAction func checkInput(_ sender: Any) {
        var checked = false as Bool
        if let label = self.cardNameText {
            if (label.text != "") {
                // good
                if let label2 = self.cardNumberText {
                    if (label2.text != "") {
                        // good
                        if let label3 = self.cardExpiryText {
                            if (label3.text != "") {
                                // good
                                if let label4 = self.cardCSVText {
                                    if (label4.text != "") {
                                        // ok set true
                                        checked = true
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        if (checked) {
            // send purchase request
            purchaseRequest()
        }
    }
    
    func purchaseRequest() {
        
        // set the url to purchase
        // http://partiklezoo.com/3dprinting/?action=purchase&u0001=2&total=120&material=pla&painting=false
        // the url                              purchase        id=amount&total=totalPrice&material=pla&painting=false
        // so we need to format the string before making it do its thing
        // we need to find the amount of items in the cart before making the url(s), this is due tot he fact that u cant buy two items in one url if they are different ids
        // so lets count
        let countOfCart = model.cart.count
        if (countOfCart == 0) {
            return
        }
        // now we need to get each uid from the cart
        var cartUIDs = [String]()
        for index in 0...countOfCart - 1 {
            cartUIDs.append(model.cart[index].uid)
        }
        var cartPrices = [String]()
        for dindex in 0...countOfCart - 1 {
            let priceIndex = model.cart[dindex].price.index(model.cart[dindex].price.startIndex, offsetBy: 2) // doesnt work for all models
            let stringApp = model.cart[dindex].price.substring(to: priceIndex)
            if (abs == true && painting == true) {
                let tempString = String(bothPrices).substring(to: priceIndex)
                cartPrices.append(tempString)
                material = "abs";
                isPainting = "true";
            } else if (abs == true) {
                let tempString = String(absPrice).substring(to: priceIndex)
                cartPrices.append(tempString)
                material = "abs";
                print(tempString)
            } else if (painting == true) {
                let tempString = String(printingPrice).substring(to: priceIndex)
                cartPrices.append(tempString)
                material = "abs";
                isPainting = "true";
                print(tempString)
            } else {
                cartPrices.append(stringApp)
            }
        }
        
        // ok now we have the uid and amount of items we can now set up the urls in another array
        var urls = [String]()
        for vindex in 0...countOfCart - 1 {
            urls.append("http://partiklezoo.com/3dprinting/?action=purchase&" + cartUIDs[vindex] + "=1&total=" + cartPrices[vindex] + "&material=" + material + "&painting=" + isPainting)
        }
        let url = NSURL(string: urls[0])
        let config = URLSessionConfiguration.default
        config.isDiscretionary = true
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: url! as URL, completionHandler:
            {(data, response, error) in
                do {
                    let json = try JSON(data: data!)
                    // so we got the json, it should either be true or false
                    // if true, return a popup saying purchased, if false we should display a message saying invalid purchase
                    if (json["success"] == "true") {
                        let alertController = UIAlertController(title: "Success!", message:
                            "Purchased Item(s) Successfully!", preferredStyle: UIAlertControllerStyle.alert)
                        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                        DispatchQueue.main.async() {
                            self.present(alertController, animated: true, completion: nil)
                        }
                    } else { // this shouldn't get called ever, but just incase the server goes down or something
                        let alertController = UIAlertController(title: "ERROR!", message:
                            "Payment Rejected (ERROR)!", preferredStyle: UIAlertControllerStyle.alert)
                        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                        DispatchQueue.main.async() {
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }
                }
                catch let error as NSError
                {
                    print("Could not convert. \(error), \(error.userInfo)")
                }
                
        })
        task.resume()
    }
    
    // MARK: Button Checks
    
    @IBAction func absCheck(_ button: UIButton) {
        if (abs == true) {
            button.setImage(#imageLiteral(resourceName: "Unchecked"), for: .normal)
            abs = false;
            if (painting == true) {
                if let label = self.totalPrice {
                    label.text = "$" + String(format:"%0.2f", printingPrice)
                }
            } else {
                if let label = self.totalPrice {
                    label.text = "$" + String(format:"%0.2f", ogCartPrice)
                }
            }
        } else if (abs == false) {
            button.setImage(#imageLiteral(resourceName: "Checked"), for: .normal)
            abs = true;
            if (painting == true) {
                if let label = self.totalPrice {
                    label.text = "$" + String(format:"%0.2f", bothPrices)
                }
            } else {
                if let label = self.totalPrice {
                    label.text = "$" + String(format:"%0.2f", absPrice)
                }
            }
        }
    }
    
    @IBAction func paintingCheck(_ button: UIButton) {
        if (painting == true) {
            button.setImage(#imageLiteral(resourceName: "Unchecked"), for: .normal)
            painting = false;
            if (abs == true) {
                if let label = self.totalPrice {
                    label.text = "$" + String(format:"%0.2f", absPrice)
                }
            } else {
                if let label = self.totalPrice {
                    label.text = "$" + String(format:"%0.2f", ogCartPrice)
                }
            }
        } else if (painting == false) {
            button.setImage(#imageLiteral(resourceName: "Checked"), for: .normal)
            painting = true;
            if (abs == true) {
                if let label = self.totalPrice {
                    label.text = "$" + String(format:"%0.2f", bothPrices)
                }
            } else {
                if let label = self.totalPrice {
                    label.text = "$" + String(format:"%0.2f", printingPrice)
                }
            }
        }
    }
    
    
    
    
}
