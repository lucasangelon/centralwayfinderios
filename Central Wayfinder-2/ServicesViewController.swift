//
//  ServicesViewControllers.swift
//  Central Wayfinder-2
//
//  Created by Lucas Angelon Arouca on 15/10/2015.
//  Copyright © 2015 Lucas Angelon Arouca. All rights reserved.
//

import UIKit

class ServicesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    var services: [Room] = [Room]()
    var currentRow: Room = Room()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Show the navigation bar.
        self.navigationController?.navigationBarHidden = false
        self.tabBarController?.tabBar.hidden = false
        
        services = sharedInstance.getServices(sharedDefaults.campusId, rooms: services)
        
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
        
        performSegueWithIdentifier("ShowMapsFromServices", sender: self)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // Prepare for the Segue by sending all information required to the Google Maps View Controller.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier != "ReturnFromServices" {
            // Set up the coordinates and the title of the location.
            let destinationSegue = segue.destinationViewController as! MapsViewController
            destinationSegue.createRoute(currentRow.name, buildingId: currentRow.buildingId)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
