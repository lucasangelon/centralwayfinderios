//
//  MainMenuViewController.swift
//  Central Wayfinder-2
//
//  Created by Lucas Angelon Arouca on 15/10/2015.
//  Copyright © 2015 Lucas Angelon Arouca. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Declaring the base tableView.
    @IBOutlet var tableView: UITableView!
    
    // List items for the main menu.
    let cellContent = ["Map", "Services", "Central Web", "Settings"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Returns the item count from the list based on the "cellContent" variable.
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cellContent.count
    }
    
    // Returns the properly set up items for the list.
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        cell.textLabel?.text = cellContent[indexPath.row]
        cell.imageView?.image = UIImage(named: "swiftIcon")
        
        return cell
    }
    
    // handling the clicks on the table items.
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
            
            // When the "Map" item is clicked.
        case 0:
            
            // Perform Segue.
            self.performSegueWithIdentifier("ShowMapSegue", sender: self)
            
            // When the "Services" item is clicked.
        case 1:
            self.performSegueWithIdentifier("ShowServicesSegue", sender: self)
            
            // When the "Central Web" item is clicked, open the website on the default browser for the system.
        case 2:
            
            // Open the browser and go to central.wa.edu.au
            let url = NSURL(string: "http://central.wa.edu.au")!
            UIApplication.sharedApplication().openURL(url)
            
            // When the "Settings" item is clicked.
        case 3:
            self.performSegueWithIdentifier("ShowSettingsSegue", sender: self)
            
            // Default action.
        default:
            print("NoSegueAvailable")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}



