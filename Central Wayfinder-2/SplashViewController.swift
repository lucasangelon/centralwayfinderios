

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
    private var downloadGroup = dispatch_group_create()
    
    // Declaring the location manager.
    private var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.hidden = true
        
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor(red: (236/255), green: (104/255), blue: (36/255), alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
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
        
        
        let globalUserInitiatedQueue = dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)
        
        dispatch_async(globalUserInitiatedQueue) {
            
            // Service Connection
            dispatch_group_enter(self.downloadGroup)
            self.webServicesHelper.checkServiceConnection() {
                void in
                dispatch_group_leave(self.downloadGroup)
            }
            
            // Database Connection
            dispatch_group_enter(self.downloadGroup)
            self.webServicesHelper.checkDatabaseConnection() {
                void in
                dispatch_group_leave(self.downloadGroup)
            }
            
            // Wait until both methods above complete their tasks.
            dispatch_group_wait(self.downloadGroup, DISPATCH_TIME_FOREVER)
            
            if self.webServicesHelper.serviceConnection == "true" && self.webServicesHelper.databaseConnection == "true" {
                if sharedInstance.checkCampuses() {
                    // Campuses are there, no need to re-download.
                    
                    let nsud = NSUserDefaults()
                    if (nsud.objectForKey("selectedCampus")) == nil {
                        sharedDefaults.campusId = "PE"
                        sharedDefaults.campusName = "Perth"
                        sharedDefaults.campusVersion = -1
                        sharedDefaults.campusDefaultLat = 31.9476680755615
                        sharedDefaults.campusDefaultLong = 115.862129211426
                    }
                    
                    let globalUserInitiatedQueue = dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)
                    
                    // Go to a separate thread.
                    dispatch_async(globalUserInitiatedQueue) {
                        
                        var versionCheck = Bool()
                        
                        // Check campus version.
                        dispatch_group_enter(self.downloadGroup)
                        self.webServicesHelper.checkCampusVersion(sharedDefaults.campusVersion) {
                            void in
                            dispatch_group_leave(self.downloadGroup)
                        }
                        
                        // Wait until the method finishes running.
                        dispatch_group_wait(self.downloadGroup, DISPATCH_TIME_FOREVER)
                        
                        versionCheck = self.webServicesHelper.getCampusVersionCheck()
                        
                        // If the versions differ, download the new version.
                        if !versionCheck {
                            dispatch_group_enter(self.downloadGroup)
                            
                            // Download updated rooms for the current campus.
                            self.webServicesHelper.downloadRooms(sharedDefaults.campusId) {
                                void in
                                dispatch_group_leave(self.downloadGroup)
                            }
                            
                            // Wait until the download finishes.
                            dispatch_group_wait(self.downloadGroup, DISPATCH_TIME_FOREVER)
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                // Clear the existing rooms.
                                sharedInstance.removeRooms()
                                
                                // Download new rooms.
                                sharedInstance.insertRooms(self.webServicesHelper.getRooms())
                                
                                self.activityIndicator.hidden = true
                                self.application.endIgnoringInteractionEvents()
                            })
                        } else {
                            dispatch_async(dispatch_get_main_queue(), {
                                self.activityIndicator.hidden = true
                                self.application.endIgnoringInteractionEvents()
                            })
                        }
                    }
                } else {
                    // Download Campuses
                    dispatch_group_enter(self.downloadGroup)
                    self.webServicesHelper.downloadCampuses() {
                        void in
                        dispatch_group_leave(self.downloadGroup)
                    }
                    
                    // Wait until the campuses have been downloaded.
                    dispatch_group_wait(self.downloadGroup, DISPATCH_TIME_FOREVER)
                    
                    self.campuses = self.webServicesHelper.getCampuses()
                    
                    // Return to the main thread.
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        // Checking if "campuses" is not empty.
                        if self.webServicesHelper.checkCampuses() {
                            
                            // Inserts campuses from the web service into the database.
                            sharedInstance.insertCampuses(self.campuses)
                            
                            self.activityIndicator.hidden = true
                            self.application.endIgnoringInteractionEvents()
                        } else {
                            self.activityIndicator.hidden = true
                            self.application.endIgnoringInteractionEvents()
                            
                            // Handling the alert to explain the web service did not run as expected.
                            let alert: UIAlertController = UIAlertController(title: "No Campuses Found", message: "The system was unable to retrieve the campuses. Please try again later.", preferredStyle: .Alert)
                            
                            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                            
                            self.presentViewController(alert, animated: true, completion: nil)
                        }
                    })
                }
            } else {
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.activityIndicator.hidden = true
                    self.application.endIgnoringInteractionEvents()
                    
                    // Handling the alert to explain the web service did not run as expected.
                    let alert: UIAlertController = UIAlertController(title: "Connection Error", message: "The system was unable to retrieve the campuses. Please try again later.", preferredStyle: .Alert)
                    
                    alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                    
                    self.presentViewController(alert, animated: true, completion: nil)
                })
            }
        }
    }

    override func viewDidAppear(animated: Bool) {
        NSThread.sleepForTimeInterval(3)
                
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