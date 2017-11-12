//
//  FinderViewController.swift
//  ShoppingApp
//
//  Created by Porcaro, Keano Dean - porkd002 on 12/11/17.
//  Copyright © 2017 Porcaro, Keano Dean - porkd002. All rights reserved.
//

import UIKit
import MapKit

class FinderViewController: DetailViewController, UISearchBarDelegate {
    
    @IBOutlet var searchBarMap: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var closestLocation: UILabel!
    
    @IBOutlet weak var coords: UILabel!
    @IBAction func getClosestLocation(_ sender: Any) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBarMap.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBarMap.resignFirstResponder()
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(searchBarMap.text!) { (placemarks:[CLPlacemark]?, error:Error?) in
            if error == nil {
                
                let placemark = placemarks?.first
                
                let anno = MKPointAnnotation()
                anno.coordinate = (placemark?.location?.coordinate)!
                anno.title = self.searchBarMap.text!
                
                let span = MKCoordinateSpanMake(0.075, 0.075)
                let region = MKCoordinateRegion(center: anno.coordinate, span: span)
                
                self.mapView.setRegion(region, animated: true)
                self.mapView.addAnnotation(anno)
                self.mapView.selectAnnotation(anno, animated: true)
                
                // now get the coords from the placemarker
                
                let long = placemark?.location?.coordinate.longitude
                
                let lat = placemark?.location?.coordinate.latitude
                
                self.coords.text = "Coords: " + String(lat!) + ", " + String(long!)
                                // lets now find the closest store
                // we have to do a JSON call to the server with their coords, we can cut some of it out
                let coordURL = "http://partiklezoo.com/3dprinting/?action=locations&coord1=" + String(lat!) + "&coord2=" + String(long!)
                let url = NSURL(string: coordURL)
                let config = URLSessionConfiguration.default
                config.isDiscretionary = true
                let session = URLSession(configuration: config)
                var result = ""
                let task = session.dataTask(with: url! as URL, completionHandler:
                    {(data, response, error) in
                        do {
                            let json = try JSON(data: data!)
                            DispatchQueue.main.async() {
                                self.closestLocation.text = json[0]["street"].string! + ", " + json[0]["suburb"].string!
                            }
                            
                        }
                        catch let error as NSError
                        {
                            print("Could not convert. \(error), \(error.userInfo)")
                        }
                        
                })
                task.resume()
                //print(result)
                //self.closestLocation.text = result
                
                
                
            }else{
                print(error?.localizedDescription ?? "error")
            }
            
        }
        
    }
    
    

}
