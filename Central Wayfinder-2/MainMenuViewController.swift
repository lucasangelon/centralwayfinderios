//
//  MainMenuViewController.swift
//  Central Wayfinder-2
//
//  Created by Lucas Angelon Arouca on 15/10/2015.
//  Copyright © 2015 Lucas Angelon Arouca. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    // Declaring the base tableView.
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var imageView: UIImageView!
    
    private var rooms: [Room] = [Room]()
    private var roomNames: [String] = [String]()
    private var selectedRoom: Room = Room()
    private var building: Building = Building()
    private let webServicesHelper = WebServicesHelper()
    
    // List items for the main menu.
    private let cellContent = ["Services", "Central Web", "Settings"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Adds a tap gesture to dismiss the keyboard anywhere in the screen.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        // Ensures the keyboard dismissal will not stop touches in the table view.
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        // Paint the navigation bar in white after the Splash Screen.
        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        
        // Ensures the tab bar is hidden on the main menu in order to avoid duplicate options on the page.
        self.tabBarController?.tabBar.hidden = true
        
        // Setting up the arrays for the searching cell.
        rooms = sharedInstance.getRooms(sharedDefaults.campusId, rooms: rooms)
        
        if rooms.count > 0 {
            for index in 0...(rooms.count - 1) {
                roomNames.append(rooms[index].name)
            }
        } else {
            print("No Rooms found for this campus.")
        }
        
        
        self.searchBar.placeholder = "Enter Room"
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // Ensures the navigation bar is hidden in this page.
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
    // Returns the item count from the list based on the "cellContent" variable.
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cellContent.count
    }
    
    // Returns the properly set up items for the list.
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ImageTextArrowCell", forIndexPath: indexPath)
        
        cell.textLabel?.text = cellContent[indexPath.row]
        cell.imageView?.image = UIImage(named: "swiftIcon")
        
        return cell
    }
    
    // handling the clicks on the table items.
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
            
            // When the "Services" item is clicked.
        case 0:
            self.performSegueWithIdentifier("ShowServicesViewController", sender: self)
            
            // When the "Central Web" item is clicked, open the website on the default browser for the system.
        case 1:
            
            // Open the browser and go to central.wa.edu.au
            let url = NSURL(string: "http://central.wa.edu.au")!
            UIApplication.sharedApplication().openURL(url)
            
            // When the "Settings" item is clicked.
        case 2:
            self.performSegueWithIdentifier("ShowSettingsViewController", sender: self)
            
            // Default action.
        default:
            print("NoSegueAvailable")
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // When the user clicks on the search button.
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        var found = false
        var positionFound = 0
        
        if rooms.count > 0 {
            
            // Search for the room.
            for index in 0...(roomNames.count - 1) {
                if roomNames[index] == searchBar.text {
                    found = true
                    positionFound = index
                }
            }
        }
        
        if found {
            selectedRoom = rooms[positionFound]
            
            building =  sharedInstance.getBuilding(selectedRoom.buildingId, building: building)
            
            if building.id == 0 {
                
                let dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                let dispatchGroup: dispatch_group_t = dispatch_group_create()
                
                // Tries downloading the building and saving it into the database.
                dispatch_group_async(dispatchGroup, dispatchQueue, {
                    self.webServicesHelper.downloadBuilding(self.selectedRoom.buildingId)
                    print("Downloading building.")
                })
                
                dispatch_group_notify(dispatchGroup, dispatchQueue, {
                    NSThread.sleepForTimeInterval(4.0)
                    self.building = self.webServicesHelper.getBuilding()
                    print("Loaded building.")
                })
            }
            
            self.performSegueWithIdentifier("ShowMapsFromMenu", sender: self)
        } else {
            // Handling the alert to explain the room could not be found at this specific campus.
            let alert: UIAlertController = UIAlertController(title: "Could not find location", message: "The location you searched for does not exist at the \(sharedDefaults.campusName) campus.", preferredStyle: .Alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        self.searchBar.endEditing(true)

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowMapsFromMenu" {
            let destinationSegue = segue.destinationViewController as! MapsViewController
            
            destinationSegue.building = building
            destinationSegue.destSubtitle = selectedRoom.name
        }
        
        // Clears the search bar prior to changing screens.
        searchBar.text = ""
    }
    
    // Dismisses the keyboard.
    func dismissKeyboard() {
        self.searchBar.endEditing(true)
    }
}