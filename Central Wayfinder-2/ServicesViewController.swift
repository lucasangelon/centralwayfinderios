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
        self.title = "Facilities"


        self.tabBarController?.tabBar.hidden = false
        
        activityIndicator.hidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        services = [Room]()
        services = sharedInstance.getServices(sharedDefaults.campusId, rooms: services)
        
        if services.count < 1 {
            tableView.allowsSelection = false
        } else {
            tableView.allowsSelection = true
        }
        
        tableView.reloadData()
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
            cell.imageView?.image = nil
            cell.accessoryView = UIImageView(frame: CGRectMake(0, 0, 0, 0))
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
        
        // Starts a dispatch_group, utilized for the web services.
        let downloadGroup = dispatch_group_create()
        
        // Ensures its priority by settings the Quality of Service type.
        let globalUserInitiatedQueue = dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)
        
        // Sends it to a separate thread.
        dispatch_async(globalUserInitiatedQueue) {
            
            // Enters the group.
            dispatch_group_enter(downloadGroup)
            
            // Executes the service call, sends a "leave group" block in order to confirm when it is concluded.
            self.webServicesHelper.downloadBuilding(self.currentRow.id, buildingId: self.currentRow.buildingId) {
                void in
                dispatch_group_leave(downloadGroup)
            }
            
            // Waits until the thread has nothing more running (until the "leave" block is executed).
            dispatch_group_wait(downloadGroup, DISPATCH_TIME_FOREVER)
            
            // Returns to the main thread and execute necessary processing.
            dispatch_async(dispatch_get_main_queue(), {
                self.building = sharedIndoorMaps.getBuilding()
                
                if self.building.id != 0 {
                    self.activityIndicator.hidden = true
                    application.endIgnoringInteractionEvents()
                    tableView.deselectRowAtIndexPath(indexPath, animated: true)
                    
                    self.performSegueWithIdentifier("ShowMapsFromServices", sender: self)
                } else {
                    self.activityIndicator.hidden = true
                    application.endIgnoringInteractionEvents()
                    tableView.deselectRowAtIndexPath(indexPath, animated: true)
                    
                    // Handling the alert to explain the web service did not run as expected.
                    let alert: UIAlertController = UIAlertController(title: "Connection Error", message: "The system was unable to retrieve the required maps.", preferredStyle: .Alert)
                    
                    alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                    
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            })
        }
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