//
//  SearchViewController.swift
//  Central Wayfinder-2
//
//  Created by Lucas Angelon Arouca on 5/11/2015.
//  Copyright © 2015 Lucas Angelon Arouca. All rights reserved.
//

import Foundation
import UIKit

class SearchViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    @IBOutlet weak var searchTable: UITableView!
    
    // Declaring item arrays and search controller.
    private var rooms: [Room] = [Room]()
    private var defaultItems: [String] = [String]()
    private var filteredItems = [String]()
    private var resultSearchController = UISearchController()
    private var selectedRoom: Room = Room()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden = false
        
        rooms = sharedInstance.getRooms(sharedDefaults.campusId, rooms: rooms)
        
        for index in 0...(rooms.count - 1) {
            defaultItems.append(rooms[index].name)
        }
        
        // Setting the search controller up.
        self.resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            
            self.searchTable.tableHeaderView = controller.searchBar
            
            return controller
        })()
        
        // Reloads table data.
        self.searchTable.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // Returns the correct item count based on filtered / normal data.
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.resultSearchController.active) {
            return self.filteredItems.count
        } else {
            return self.defaultItems.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TextCell", forIndexPath: indexPath) as UITableViewCell
        
        if (self.resultSearchController.active) {
            cell.textLabel?.text = filteredItems[indexPath.row]
        } else {
            cell.textLabel?.text = defaultItems[indexPath.row]
        }
        
        return cell
    }
    
    // Upon selection of an item.
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // Set the service coordinates and the title to a variable to be sent to Google Maps.
        selectedRoom = rooms[indexPath.row]
        
        self.performSegueWithIdentifier("ShowMapsFromSearch", sender: self)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // Setting up the footer.
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 10))
        
        return footerView
    }
    
    // Adding the autocomplete search for the table.
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filteredItems.removeAll(keepCapacity: false)
        
        // Creating a predicate to search for in the list items.
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        
        let array = (defaultItems as NSArray).filteredArrayUsingPredicate(searchPredicate)
        filteredItems = array as! [String]
        
        self.searchTable.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowMapsFromSearch" {
            
            // Set up the coordinates and the title of the location.
            let destinationSegue = segue.destinationViewController as! MapsViewController
            destinationSegue.destTitle = selectedRoom.name
            destinationSegue.destBuildingId = selectedRoom.buildingId
        }
    }
}