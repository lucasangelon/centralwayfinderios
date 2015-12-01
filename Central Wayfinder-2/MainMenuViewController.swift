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
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let webServicesHelper = WebServicesHelper()
    private let application = UIApplication.sharedApplication()
    private var rooms: [Room] = [Room]()
    private var roomNames: [String] = [String]()
    private var selectedRoom: Room = Room()
    private var postMapsInformation = [String]()
    private var building: Building = Building()
    
    // List items for the main menu.
    private let cellContent = [("Services", "services.png"), ("Central Web", "centralWeb.png"), ("Settings", "settings.png")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Generating the navigation Bar
        let navigationBar = UINavigationBar(frame: CGRectMake(0,0, self.view.frame.size.width, 60))
        navigationBar.translucent = false
        navigationBar.barTintColor = UIColor(red: (236/255), green: (104/255), blue: (36/255), alpha: 1)
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationBar.tintColor = UIColor.whiteColor()
        
        let navigationItem = UINavigationItem()
        navigationItem.title = "Home"
        navigationBar.items = [navigationItem]
        
        self.view.addSubview(navigationBar)
        
        activityIndicator.hidden = true
        
        // Adds a tap gesture to dismiss the keyboard anywhere in the screen.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        // Ensures the keyboard dismissal will not stop touches in the table view.
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        self.navigationController?.interactivePopGestureRecognizer?.enabled = false
        
        // Ensures the tab bar is hidden on the main menu in order to avoid duplicate options on the page.
        self.tabBarController?.tabBar.hidden = true
        
        // Setting up the arrays for the searching cell.
        rooms = sharedInstance.getRooms(sharedDefaults.campusId, rooms: rooms)
        
        if rooms.count > 0 {
            for index in 0...(rooms.count - 1) {
                roomNames.append(rooms[index].name)
            }
        }
        
        self.searchBar.placeholder = "Enter Room"
    }
    
    override func viewDidAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = true
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
        tableView.separatorColor = UIColor(red: (236/255), green: (104/255), blue: (36/255), alpha: 1)
        return cellContent.count
    }
    
    // Returns the properly set up items for the list.
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TextImageArrowCell", forIndexPath: indexPath)
        
        cell.textLabel?.text = cellContent[indexPath.row].0
        cell.imageView?.image = UIImage(named: cellContent[indexPath.row].1)
        cell.accessoryView = UIImageView(image: UIImage(named: "disclosureIndicator.png"))
        cell.accessoryView?.frame = CGRectMake(0,0,40,40)
        
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
    
    // Setting up the footer.
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 10))
        
        return footerView
    }
    
    // When the user clicks on the search button.
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        
        self.view.bringSubviewToFront(activityIndicator)
        
        self.application.beginIgnoringInteractionEvents()
        
        var found = false
        var positionFound = 0
        
        if rooms.count > 0 {
            
            // Search for the room.
            for index in 0...(roomNames.count - 1) {
                
                // Ensures both strings are in lowercase and avoids errors with capitalised letters.
                if roomNames[index].lowercaseString == searchBar.text?.lowercaseString {
                    found = true
                    positionFound = index
                    break
                }
            }
        }
        
        if found {
            selectedRoom = rooms[positionFound]
            
            let dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
            let dispatchGroup: dispatch_group_t = dispatch_group_create()
            
            // Tries downloading the building and saving it into the database.
            dispatch_group_async(dispatchGroup, dispatchQueue, {
                self.webServicesHelper.downloadBuilding(self.selectedRoom.id, buildingId: self.selectedRoom.buildingId)
            })
            
            dispatch_group_notify(dispatchGroup, dispatchQueue, {
                NSThread.sleepForTimeInterval(29.0)
                
                self.building = sharedIndoorMaps.getBuilding()
                
                if self.building.id != 0 {
                
                    dispatch_async(dispatch_get_main_queue(), {
                        self.activityIndicator.hidden = true
                        self.application.endIgnoringInteractionEvents()
                        
                        self.goToMaps()
                    })
                } else {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.activityIndicator.hidden = true
                        self.application.endIgnoringInteractionEvents()
                        
                        // Handling the alert to explain the web service did not run as expected.
                        let alert: UIAlertController = UIAlertController(title: "Connection Error", message: "The system was unable to retrieve the required maps.", preferredStyle: .Alert)
                        
                        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                        
                        self.presentViewController(alert, animated: true, completion: nil)
                    })
                }
            })
        } else {
            self.activityIndicator.hidden = true
            self.application.endIgnoringInteractionEvents()
            
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
            
            destinationSegue.building = self.building
            destinationSegue.destSubtitle = selectedRoom.name
        }
        
        // Clears the search bar prior to changing screens.
        searchBar.text = ""
    }
    
    // Dismisses the keyboard.
    func dismissKeyboard() {
        self.searchBar.endEditing(true)
    }
    
    func goToMaps() {
        self.performSegueWithIdentifier("ShowMapsFromMenu", sender: self)
    }
}