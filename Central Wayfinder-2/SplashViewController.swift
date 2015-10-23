//
//  SplashViewController.swift
//  Central Wayfinder-2
//
//  Created by Lucas Angelon Arouca on 15/10/2015.
//  Copyright © 2015 Lucas Angelon Arouca. All rights reserved.
//

import UIKit
import CoreLocation

class SplashViewController: UIViewController, CLLocationManagerDelegate, UIApplicationDelegate {
    
    @IBOutlet var startButton: UIButton!
    
    // Declaring the location manager.
    var locationManager = CLLocationManager()
    let userDefaults = UserDefaultsController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configuring the location manager.
        locationManager.delegate = self
    }
    
    // Handling the alert window in the right hierarchy.
    override func viewDidAppear(animated: Bool) {
        
        // If the location services status has not been set, prompt the user for it.
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.NotDetermined {
            if #available(iOS 8.0, *) {
                locationManager.requestWhenInUseAuthorization()
            } else {
                // Fallback on earlier versions
            }
        }
        
        // If the location services has been refused or restricted, show an alert to the user.
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.Denied || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.Restricted {
            
            alert("Location Services Alert", message: "In order to improve your experience with Central Wayfinder, please authorize location services to be used while the application is open.")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Handles the alerts related to the location service options and authorizations.
    func alert(title: String, message: String) {
        
        // If iOS 8:
        if #available(iOS 8.0, *) {
            let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            
            // Adding the "Cancel" action.
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            
            // Adding the "Location Services Settings action.
            let locationServicesAction = UIAlertAction(title: "Location Service Settings", style: .Default) {
                (action) in
                if let url = NSURL(string: UIApplicationOpenSettingsURLString) {
                    
                    // Sending the user to the pre-defined url.
                    UIApplication.sharedApplication().openURL(url)
                }
            }
            
            // Adding the actions to the alert.
            alert.addAction(cancelAction)
            alert.addAction(locationServicesAction)
            
            // Present the alert to the user.
            self.presentViewController(alert, animated: true, completion: nil)
        }
            
            // iOS 7 or lower:
        else {
            let alert: UIAlertView = UIAlertView()
            
            // Configuring the alert.
            alert.delegate = self
            alert.title = title
            
            // Adding the extra bit to the message.
            alert.message = message + "To do so, open Settings > Privacy > Location Services > Central Wayfinder."
            alert.addButtonWithTitle("Ok")
            
            alert.show()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "FirstUseToCampusSelection" {
            
            let destinationSegue = segue.destinationViewController as! CampusSelectionViewController
            destinationSegue.firstTimeUse()
        }
    }
    
    @IBAction func startButton(sender: AnyObject) {
        // Detecting if the user is opening the application for the first time.
        if (!userDefaults.isFirstLaunch) {
            userDefaults.isFirstLaunch = true
            self.performSegueWithIdentifier("FirstUseToCampusSelection", sender: nil)
        } else {
            self.performSegueWithIdentifier("ShowMainMenuViewController", sender: nil)
        }
    }
}
