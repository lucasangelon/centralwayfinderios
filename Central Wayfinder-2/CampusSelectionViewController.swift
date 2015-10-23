//
//  CampusSelectionViewController.swift
//  Central Wayfinder-2
//
//  Created by Lucas Angelon Arouca on 23/10/2015.
//  Copyright © 2015 Lucas Angelon Arouca. All rights reserved.
//

import UIKit

class CampusSelectionViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var backButton: UIBarButtonItem!
    
    let userDefaults = UserDefaultsController()
    var firstUse = false
    
    // Adding the back button action to the barButtonItem. 
    // Make sure to remember to link it to the viewController action using control + touchpad on the Storyboard in order
    // for it to work!
    @IBAction func backButton(sender: UIBarButtonItem) {
        
        // If using the application for the first time.
        if firstUse {
            
            // Declaring the userDefaults again in order to check for nulls.
            let nsud = NSUserDefaults()
            
            if (nsud.objectForKey("selectedCampus") != nil) { }
            else {
                
                // If the user clicked the back button instead of selecting a campus, default to Perth Campus.
                userDefaults.campusName = campusInformation[0].0
                userDefaults.campusDefaultLat = campusInformation[0].1
                userDefaults.campusDefaultLong = campusInformation[0].2
            }
            
            self.performSegueWithIdentifier("ReturnFromFirstUse", sender: self)
        } else {
            self.performSegueWithIdentifier("ReturnFromCampusSelection", sender: self)
        }
    }
    
    // List items for the menu.
    let cellContent = ["Perth", "Leederville", "East Perth", "Mount Lawley", "Nedlands"]
    
    //TODO: Remove this list after setting up Internal Storage.
    let campusInformation = [("Perth", -31.9476680755615, 115.862129211426), ("Leederville", -31.9339389801025, 115.842643737793), ("East Perth", -31.9512138366699, 115.872375488281), ("Mount Lawley", -31.939432144165, 115.875679016113), ("Nedlands", -31.9700088500977, 115.81575012207)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Setting up the footer.
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 10))
        
        return footerView
    }
    
    // Returns the item count from the list based on the cellContent variable.
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellContent.count
    }
    
    // Returns the properly set up items for the list.
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TextCell", forIndexPath: indexPath)
        
        cell.textLabel?.text = cellContent[indexPath.row]
        
        return cell
    }
    
    // handling the clicks on the table items.
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        userDefaults.campusName = campusInformation[indexPath.row].0
        userDefaults.campusDefaultLat = campusInformation[indexPath.row].1
        userDefaults.campusDefaultLong = campusInformation[indexPath.row].2
        
        if firstUse {
            firstUse = false
            self.performSegueWithIdentifier("ReturnFromFirstUse", sender: self)
        } else {
            self.performSegueWithIdentifier("ReturnFromCampusSelection", sender: self)
        }
    }
    
    // Sets a boolean depending on previous viewController's prepareForSegue (SplashScreen during first use).
    func firstTimeUse() {
        firstUse = true
    }
}
