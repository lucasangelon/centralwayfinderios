//
//  CampusSelectionViewController.swift
//  Central Wayfinder-2
//
//  Created by Lucas Angelon Arouca on 23/10/2015.
//  Copyright © 2015 Lucas Angelon Arouca. All rights reserved.
//

import UIKit

class CampusSelectionViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let webServicesHelper: WebServicesHelper = WebServicesHelper()
    private let application = UIApplication.sharedApplication()
    private var campuses: [Campus] = [Campus]()
    private var campus: Campus = Campus()
    private var firstUse = false
    private var firstUseBackPress = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if firstUse {
            // Generating the navigation bar programatically
            let navigationBar = UINavigationBar(frame: CGRectMake(0,0, self.view.frame.size.width, 60))
            
            navigationBar.translucent = false
            navigationBar.backgroundColor = UIColor(red: (236/255), green: (104/255), blue: (36/255), alpha: 1)
            navigationBar.barTintColor = UIColor(red: (236/255), green: (104/255), blue: (36/255), alpha: 1)
            navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
            navigationBar.tintColor = UIColor.whiteColor()

            
            let navigationItem = UINavigationItem()
            navigationItem.title = "Select Campus"
            
            // Hiding the usual back button and implementing a special one for the campus selection page.
            let campusSelectionBackButton = UIBarButtonItem(title: "< Back", style: UIBarButtonItemStyle.Plain, target: self, action: "back:")
            navigationItem.leftBarButtonItem = campusSelectionBackButton
            
            navigationBar.items = [navigationItem]
            
            self.view.addSubview(navigationBar)
            self.tableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0)
        } else {
            self.navigationController?.navigationBar.hidden = false

            self.navigationController?.navigationBar.translucent = false
            self.navigationController?.navigationBar.barTintColor = UIColor(red: (236/255), green: (104/255), blue: (36/255), alpha: 1)
            self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
            self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        }
        
        activityIndicator.hidden = true
        
        // Database Interaction
        campuses = sharedInstance.getCampuses(campuses)
    }
    
    // Setting up the footer.
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 10))
        
        return footerView
    }
    
    // Setting up the header.
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    // Returns the item count from the list based on the cellContent variable.
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if campuses.count > 0 {
            tableView.separatorColor = UIColor(red: (236/255), green: (104/255), blue: (36/255), alpha: 1)
            
            return campuses.count
        } else {
            return 1
        }
    }
    
    // Returns the properly set up items for the list.
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TextCell", forIndexPath: indexPath)
        
        if campuses.count < 1 {
            cell.textLabel?.text = "No campuses available."
            tableView.allowsSelection = false
        } else {
            cell.textLabel?.text = campuses[indexPath.row].name
        }
        return cell
    }
    
    // handling the clicks on the table items.
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        
        self.view.bringSubviewToFront(activityIndicator)
        self.application.beginIgnoringInteractionEvents()
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        sharedDefaults.campusId = campuses[indexPath.row].id
        sharedDefaults.campusDefaultLat = campuses[indexPath.row].lat
        sharedDefaults.campusDefaultLong = campuses[indexPath.row].long
        sharedDefaults.campusName = campuses[indexPath.row].name
        sharedDefaults.campusVersion = campuses[indexPath.row].version
        
        // Downloads rooms for a given campus.
        getRooms()
    }
    
    // Handling the special back button.
    func back(sender: UIBarButtonItem) {
        
        // If using the application for the first time.
        if firstUse {
            
            activityIndicator.hidden = false
            activityIndicator.startAnimating()
            
            self.view.bringSubviewToFront(activityIndicator)
            
            self.application.beginIgnoringInteractionEvents()
            
            firstUseBackPress = true
            
            campus = sharedInstance.getCampus("PE", campus: campus)
            
            // Declaring the userDefaults again in order to check for nulls.
            let nsud = NSUserDefaults()
            
            if (nsud.objectForKey("selectedCampus") != nil) { }
            else {
                
                // If the user clicked the back button instead of selecting a campus, default to Perth Campus.
                sharedDefaults.campusId = campus.id
                sharedDefaults.campusDefaultLat = campus.lat
                sharedDefaults.campusDefaultLong = campus.long
                sharedDefaults.campusName = campus.name
                sharedDefaults.campusVersion = campus.version
                sharedDefaults.accessibility = false
            }
            
            // Downloads rooms from the web service.
            getRooms()
        } else {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    // Sets a boolean depending on previous viewController's prepareForSegue (SplashScreen during first use).
    func firstTimeUse() {
        firstUse = true
    }
    
    // Returns to the main menu after cancelling the default campus selection in iOS 8.0+.
    private func returnToMainMenu() {
        self.performSegueWithIdentifier("ReturnFromFirstUse", sender: self)
    }
    
    // Returns to the main menu after cancelling the default campus selection in iOS versions prior to 8.0.
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        self.performSegueWithIdentifier("ReturnFromFirstUse", sender: self)
    }
    
    // Retrieves rooms from the web service based on the campus.
    func getRooms() {
        
        let downloadGroup = dispatch_group_create()
        let globalUserInitiatedQueue = dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)
        
        dispatch_async(globalUserInitiatedQueue) {
            dispatch_group_enter(downloadGroup)
            
            self.webServicesHelper.downloadRooms(sharedDefaults.campusId) {
                void in
                dispatch_group_leave(downloadGroup)
            }
            
            dispatch_group_wait(downloadGroup, DISPATCH_TIME_FOREVER)
            
            dispatch_async(dispatch_get_main_queue(), {
                sharedInstance.removeRooms()
                
                self.activityIndicator.hidden = true
                self.application.endIgnoringInteractionEvents()
                
                if self.webServicesHelper.checkRooms() {
                    sharedInstance.insertRooms(self.webServicesHelper.getRooms())
                    
                    if self.firstUseBackPress == true {
                        self.firstUse = false
                        sharedDefaults.accessibility = false
                        
                        // Handling the alert to explain the default Perth campus to the user.
                        let alert: UIAlertController = UIAlertController(title: "Perth Campus", message: "The default campus has been set to Perth.", preferredStyle: .Alert)
                        
                        let okAction = UIAlertAction(title: "Ok", style: .Default) {
                            (action) in
                            
                            self.returnToMainMenu()
                        }
                        alert.addAction(okAction)
                        
                        self.presentViewController(alert, animated: true, completion: nil)
                    } else if (self.firstUse == true) {
                        self.firstUse = false
                        sharedDefaults.accessibility = false
                        
                        self.performSegueWithIdentifier("ReturnFromFirstUse", sender: self)
                    } else {
                        self.navigationController?.popViewControllerAnimated(true)
                    }
                } else {
                    // Handling the alert to explain that there are no rooms available for this campus.
                    let alert: UIAlertController = UIAlertController(title: "\(sharedDefaults.campusName)", message: "The campus has been set to \(sharedDefaults.campusName). There are no rooms available for this campus at the moment.", preferredStyle: .Alert)
                    
                    let okAction = UIAlertAction(title: "Ok", style: .Default) {
                        (action) in
                        
                        // If there is a parent view controller, pop the current view controller.
                        if ((self.navigationController?.parentViewController) != nil) {
                            self.navigationController?.popViewControllerAnimated(true)
                        } else {
                            
                            // Otherwise return to the main menu.
                            self.returnToMainMenu()
                        }
                    }
                    alert.addAction(okAction)
                    
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            })
        }
    }
}
