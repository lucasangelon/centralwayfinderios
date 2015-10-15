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
    
    let servicesLocations = [(-31.948085, 115.861103, "Bookshop"), (-31.948085, 115.861103, "Student Services"), (-31.9475169, 115.8610747, "Library"), (-31.9475169, 115.8610747, "Cafe"), (-31.948085, 115.861103, "Gym"), (-31.9475169, 115.8610747, "International Centre")]
    var currentRow = (0.1, 0.1, "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return servicesLocations.count
    }
    
    // Prepare the tableView.
    @available(iOS 6.0, *)
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TextImageCell", forIndexPath: indexPath)
        
        // Set up the information based on the, currently, hardcoded list.
        cell.textLabel?.text = servicesLocations[indexPath.row].2
        cell.imageView?.image = UIImage(named: "swiftIcon")
        
        return cell
    }
    
    // Upon selection of an item.
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // Set the service coordinates and the title to a variable to be sent to Google Maps.
        currentRow = servicesLocations[indexPath.row]
        
        // TODO: Remove, testing purposes only.
        print(currentRow)
        
        //performSegueWithIdentifier("ShowMapsFromServiceSegue", sender: self)
    }
    
    // Prepare for the Segue by sending all information required to the Google Maps View Controller.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier != "ReturnFromServices" {
            // Set up the coordinates and the title of the location.
            //let destinationSegue = segue.destinationViewController as! GoogleMapsViewController
            //destinationSegue.createRoute(currentRow.0, dLong: currentRow.1, dTitle: currentRow.2)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
