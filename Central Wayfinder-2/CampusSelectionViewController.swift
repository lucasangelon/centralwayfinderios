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
    
    var campuses: [Campus] = [Campus]()
    var campus: Campus = Campus()
    
    var firstUse = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hiding the usual back button and implementing a special one for the campus selection page.
        self.navigationItem.backBarButtonItem?.enabled = false
        let campusSelectionBackButton = UIBarButtonItem(title: "< Back", style: UIBarButtonItemStyle.Bordered, target: self, action: "back:")
        self.navigationItem.leftBarButtonItem = campusSelectionBackButton
        
        // Database Interaction
        campuses = sharedInstance.getCampuses(campuses)
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    // Setting up the footer.
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 10))
        
        return footerView
    }
    
    // Returns the item count from the list based on the cellContent variable.
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return campuses.count
    }
    
    // Returns the properly set up items for the list.
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TextCell", forIndexPath: indexPath)
        
        cell.textLabel?.text = campuses[indexPath.row].name
        
        return cell
    }
    
    // handling the clicks on the table items.
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        sharedDefaults.campusId = campuses[indexPath.row].id
        sharedDefaults.campusDefaultLat = campuses[indexPath.row].lat
        sharedDefaults.campusDefaultLong = campuses[indexPath.row].long
        
        if firstUse {
            firstUse = false
            self.performSegueWithIdentifier("ReturnFromFirstUse", sender: self)
        } else {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    // Handling the special back button.
    func back(sender: UIBarButtonItem) {
        
        // If using the application for the first time.
        if firstUse {
            
            campus = sharedInstance.getCampus("PE", campus: campus)
            
            // Declaring the userDefaults again in order to check for nulls.
            let nsud = NSUserDefaults()
            
            if (nsud.objectForKey("selectedCampus") != nil) { }
            else {
                
                // If the user clicked the back button instead of selecting a campus, default to Perth Campus.
                sharedDefaults.campusId = campus.id
                sharedDefaults.campusDefaultLat = campus.lat
                sharedDefaults.campusDefaultLong = campus.long
            }
            
            
            
            firstUse = false
            
            self.performSegueWithIdentifier("ReturnFromFirstUse", sender: self)
            
        } else {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    // Sets a boolean depending on previous viewController's prepareForSegue (SplashScreen during first use).
    func firstTimeUse() {
        firstUse = true
    }
}
