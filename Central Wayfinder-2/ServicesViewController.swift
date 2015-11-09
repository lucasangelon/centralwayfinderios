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
    
    @IBOutlet var tableView: UITableView!
    
    private let qualityOfServiceClass = QOS_CLASS_UTILITY
    private let webServicesHelper = WebServicesHelper()
    private var services: [Room] = [Room]()
    private var currentRow: Room = Room()
    private var building: Building = Building()
    var activityIndicator = UIActivityIndicatorView()
    var queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)
    var group = dispatch_group_create()
    
    var spinner: UIActivityIndicatorView = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Show the navigation bar.
        self.navigationController?.navigationBarHidden = false
        self.tabBarController?.tabBar.hidden = false
        
        services = sharedInstance.getServices(sharedDefaults.campusId, rooms: services)
        spinner.center = CGPointMake(160, 240);
        spinner.hidesWhenStopped = true
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return services.count
    }
    
    // Prepare the tableView.
    @available(iOS 6.0, *)
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TextImageCell", forIndexPath: indexPath)
        
        // Set up the information based on the, currently, hardcoded list.
        cell.textLabel?.text = services[indexPath.row].name
        cell.imageView?.image = UIImage(named: services[indexPath.row].image)
        
        return cell
    }
    
    // Upon selection of an item.
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // Set the service coordinates and the title to a variable to be sent to Google Maps.
        currentRow = services[indexPath.row]
        
        self.view.addSubview(spinner)
        spinner.startAnimating()
        
        building = Building(id: 0)//sharedInstance.getBuilding(currentRow.buildingId, building: building)
        
        // TODO: STOP THE MAIN THREAD TO CALL WEB SERVICE D=
        if building.id == 0 {
            dispatch_group_async(group, queue,  {
                self.webServicesHelper.downloadBuilding(self.currentRow.buildingId)
                
                dispatch_sync(dispatch_get_main_queue(), {
                    self.spinner.stopAnimating()
                })
            })
            
            dispatch_group_wait(group, 5)
            
            dispatch_resume(group)
        }
        

        
        self.performSegueWithIdentifier("ShowMapsFromServices", sender: self)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
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
            
            destinationSegue.destTitle = currentRow.name
            destinationSegue.destBuildingId = currentRow.buildingId
        }
    }
}