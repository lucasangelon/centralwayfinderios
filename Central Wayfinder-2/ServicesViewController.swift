//
//  ServicesViewControllers.swift
//  Central Wayfinder-2
//
//  Created by Lucas Angelon Arouca on 15/10/2015.
//  Copyright © 2015 Lucas Angelon Arouca. All rights reserved.
//

import UIKit
import MapKit

class ServicesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let qualityOfServiceClass = QOS_CLASS_UTILITY
    private let webServicesHelper = WebServicesHelper()
    private var services: [Room] = [Room]()
    private var currentRow: Room = Room()
    private var building: Building = Building()
    private var postMapsInformation = [String]()
    var queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)
    var group = dispatch_group_create()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Show the navigation bar.
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor(red: (236/255), green: (104/255), blue: (36/255), alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()


        self.tabBarController?.tabBar.hidden = false
        
        activityIndicator.hidden = true
        
        services = sharedInstance.getServices(sharedDefaults.campusId, rooms: services)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if services.count < 1 {
            return 1
        } else {
            tableView.separatorColor = UIColor(red: (236/255), green: (104/255), blue: (36/255), alpha: 1)
            return services.count
        }
    }
    
    // Prepare the tableView.
    @available(iOS 6.0, *)
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TextImageCell", forIndexPath: indexPath)
        
        // Showing the user that there are no services available in case the
        // variable count is lower than 1. Disables selection on the tableView.
        if services.count < 1 {
            cell.textLabel?.text = "No services available."
            tableView.allowsSelection = false
        } else {
            cell.textLabel?.text = services[indexPath.row].name
            cell.imageView?.image = UIImage(named: services[indexPath.row].image)
            cell.accessoryView = UIImageView(image: UIImage(named: "disclosureIndicator.png"))
            cell.accessoryView?.frame = CGRectMake(0,0,40,40)
        }

        return cell
    }
    
    // Upon selection of an item.
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        
        self.view.bringSubviewToFront(activityIndicator)
        
        let application = UIApplication.sharedApplication()
        application.beginIgnoringInteractionEvents()
        
        // Set the service coordinates and the title to a variable to be sent to Google Maps.
        currentRow = services[indexPath.row]
        
        let dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        let dispatchGroup: dispatch_group_t = dispatch_group_create()
        
        // Tries downloading the building and saving it into the database.
        dispatch_group_async(dispatchGroup, dispatchQueue, {
            self.webServicesHelper.downloadBuilding(self.currentRow.id, buildingId: self.currentRow.buildingId)
            
            print("Downloading building.")
        })
        
        
        // The ResolvePath takes quite a long time to run. NEED A SPINNER HERE D=
        dispatch_group_notify(dispatchGroup, dispatchQueue, {
            NSThread.sleepForTimeInterval(26.0)
            self.building = sharedIndoorMaps.getBuilding()
            
            self.webServicesHelper.purgeIndoorMap(self.webServicesHelper.getIndoorMapsUrls())
            
            if self.building.id != 0 {
                dispatch_async(dispatch_get_main_queue(), {
                    self.activityIndicator.hidden = true
                    application.endIgnoringInteractionEvents()
                    tableView.deselectRowAtIndexPath(indexPath, animated: true)
                    
                    self.performSegueWithIdentifier("ShowMapsFromServices", sender: self)
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.activityIndicator.hidden = true
                    application.endIgnoringInteractionEvents()
                    tableView.deselectRowAtIndexPath(indexPath, animated: true)
                    
                    // Handling the alert to explain the web service did not run as expected.
                    let alert: UIAlertController = UIAlertController(title: "Connection Error", message: "The system was unable to retrieve the required maps.", preferredStyle: .Alert)
                    
                    alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                    
                    self.presentViewController(alert, animated: true, completion: nil)
                })
            }
        })
    }
    
    // Setting up the header.
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    // Setting up the footer.
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 10))
        
        return footerView
    }
    
    // Prepare for the Segue by sending all information required to the Google Maps View Controller.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ShowMapsFromServices" {
            let destinationSegue = segue.destinationViewController as! MapsViewController
            
            destinationSegue.building = self.building
            destinationSegue.destSubtitle = currentRow.name
        }
    }
}