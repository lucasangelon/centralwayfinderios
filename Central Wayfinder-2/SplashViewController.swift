

//
//  SplashViewController.swift
//  Central Wayfinder-2
//
//  Created by Lucas Angelon Arouca on 15/10/2015.
//  Copyright © 2015 Lucas Angelon Arouca. All rights reserved.
//

import UIKit
import CoreLocation

class SplashViewController: UIViewController, CLLocationManagerDelegate, UIApplicationDelegate, UITabBarDelegate {
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let webServicesHelper: WebServicesHelper = WebServicesHelper()
    private let util: Util = Util()
    private let application = UIApplication.sharedApplication()
    private let dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
    private var campuses: [Campus] = [Campus]()
    private var success = false
    private var campusesFound = Bool()
    
    // Declaring the location manager.
    private var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.hidden = true
        self.tabBarController?.tabBar.hidden = true
        self.startButton.hidden = true
        self.activityIndicator.hidden = true
                
        // Configuring the location manager.
        locationManager.delegate = self
        
        // Setting up the database and the queue for general access.
        sharedInstance.setupDatabase()
        sharedInstance.setupQueue()
        
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        
        self.view.bringSubviewToFront(activityIndicator)
        
        application.beginIgnoringInteractionEvents()
        
        if sharedInstance.checkCampuses() {
            // Campuses are there, no need to re-download.
            activityIndicator.hidden = true
            application.endIgnoringInteractionEvents()
            campusesFound = true
            
        } else {
            campusesFound = false
            let dispatchGroup: dispatch_group_t = dispatch_group_create()
            
            // Checks the service and the database connections.
            dispatch_group_async(dispatchGroup, dispatchQueue, {
                self.webServicesHelper.checkServiceConnection()
                self.webServicesHelper.checkDatabaseConnection()
            })
            
            // Tries downloading the campuses.
            dispatch_group_notify(dispatchGroup, dispatchQueue, {
                NSThread.sleepForTimeInterval(5.0)
                if self.webServicesHelper.serviceConnection == "true" && self.webServicesHelper.databaseConnection == "true" {
                    
                    dispatch_group_async(dispatchGroup, self.dispatchQueue, {
                        self.webServicesHelper.downloadCampuses()
                    })
                } else {
                    print("Unable to check connections.")
                }
            })
            
            // Loads the campuses into the database.
            dispatch_group_notify(dispatchGroup, dispatchQueue, {
                NSThread.sleepForTimeInterval(10.0)
                self.campuses = self.webServicesHelper.getCampuses()
                
                dispatch_async(dispatch_get_main_queue(), {
                    // Checking it "campuses" is not empty.
                    if self.webServicesHelper.checkCampuses() {
                        // Inserts campuses from the web service into the database.
                        sharedInstance.insertCampuses(self.campuses)
                        print("Campuses loaded.")
                    } else {
                        print("No campuses found.")
                    }
                    
                    self.activityIndicator.hidden = true
                    self.application.endIgnoringInteractionEvents()
                })
            })
        }
    }
    
    // Handling the alert window in the right hierarchy.
    override func viewDidAppear(animated: Bool) {
        

        // If the location services status has not been set, prompt the user for it.
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.NotDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        
        // If the location services has been refused or restricted, show an alert to the user.
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.Denied || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.Restricted {
            
            alertLocation("Location Services Alert", message: "In order to improve your experience with Central Wayfinder, please authorize location services to be used while the application is open.")
        }
        
        // If there is no internet connection:
        if !(util.isConnectedToNetwork()) {
            alertInternet("Internet Connection Alert", message: "Internet (Cellular or Wi-fi) is required to use this application. Turn on Wi-fi or Cellular data usage in order to use Central Wayfinder.")
        }
        
        if !campusesFound {
            NSThread.sleepForTimeInterval(11.5)
        }
        
        self.startButton.hidden = false
    }
    
    // Handles the alerts related to the location service options and authorizations.
    private func alertLocation(title: String, message: String) {
        
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
    
    // Alert regarding the internet connection status.
    private func alertInternet(title: String, message: String) {
        
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alert.addAction(okAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "FirstUseToCampusSelection" {
            
            let destinationSegue = segue.destinationViewController as! CampusSelectionViewController
            destinationSegue.firstTimeUse()
            
            // As this is the parent to the next viewController, setting the 
            //white color here overrides the color in the child view controllers 
            //as well.
            self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        }
    }
    
    @IBAction func startButton(sender: AnyObject) {
        // Detecting if the user is opening the application for the first time.
        if (!sharedDefaults.isFirstLaunch) {
            sharedDefaults.isFirstLaunch = true
            self.performSegueWithIdentifier("FirstUseToCampusSelection", sender: nil)
        } else {
            self.performSegueWithIdentifier("ShowMainMenuViewController", sender: nil)
        }
    }
}