//
//  FirstViewController.swift
//  MyLocations
//
//  Created by Terry Griffin on 3/24/15.
//  Copyright (c) 2015 mwsu. All rights reserved.
//

import UIKit
import CoreLocation

class CurrentLocationViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    
    var location: CLLocation?
    

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var tagButton: UIButton!
    @IBOutlet weak var getButton: UIButton!
    
    @IBAction func getLocation() {
        
        let authStatus: CLAuthorizationStatus = CLLocationManager.authorizationStatus()
        
        if authStatus == .Denied || authStatus == .Restricted {
            showLocationServicesDeniedAlert()
            return
        }
        
        if authStatus == .NotDetermined {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
    }
    
    func showLocationServicesDeniedAlert() {
        let alert = UIAlertController(title: "Location Services Disabled",
            message: "Please enable location services for this app in Settings.",
            preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default,handler: nil)
        alert.addAction(okAction)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager!,
        didFailWithError error: NSError!) {
            println("didFailWithError \(error)")
    }
    
    func locationManager(manager: CLLocationManager!,
        didUpdateLocations locations: [AnyObject]!) {
            let newLocation = locations.last as CLLocation
            println("didUpdateLocations \(newLocation)")
            
            location = newLocation
            
            updateLabels()
    }
    
    func updateLabels(){
        if let location = location{
            latitudeLabel.text = String(format: "%.8f", location.coordinate.latitude)
            longitudeLabel.text = String(format: "%.8f", location.coordinate.longitude)
        }
    }
    
    
    override func viewWillAppear(animated: Bool) {
        // Get a reference to the model data from the custom tab bar controller.
        let model = (self.tabBarController as CustomTabBarController).model
        
        // Show the we can access and update the model data from the first tab.
        // Let's just increase the age each time this tab appears and assign
        // a random name.
        //model.age++
        
        //let names = ["Larry", "Curly", "Moe"]
        //model.name = names[Int(arc4random_uniform(UInt32(names.count)))]
        
        
        //model.lat = location.coordinate.latitude
    }
    
}

