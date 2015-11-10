//
//  SettingsViewController.swift
//  Central Wayfinder-2
//
//  Created by Lucas Angelon Arouca on 15/10/2015.
//  Copyright © 2015 Lucas Angelon Arouca. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var accessibilitySwitch: UISwitch!
    @IBOutlet var tableView: UITableView!
    
    // List items for the menu.
    private let cellContent = [["Accessibility", "Select Campus"], ["About", "Terms of Service", "Privacy Policy"]]
    private var aboutTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden = false
        self.tabBarController?.tabBar.hidden = false
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return cellContent.count
    }
    
    // Setting up the color for the footers.
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 10))
        
        if section == 0 {
            footerView.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.1)
        } else {
            footerView.backgroundColor = UIColor.whiteColor()
        }
        
        
        return footerView
    }
    
    // Returns the item count from the list based on the cellContent variable.
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellContent[section].count
    }
    
    // Returns the properly set up items for the list.
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell
        
        if indexPath.section == 0 && indexPath.row == 0 {
            cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath)
            
            cell.textLabel?.text = "Accessibility"
            
            let accessibilitySwitch = UISwitch(frame: CGRectZero) as UISwitch
            accessibilitySwitch.addTarget(self, action: "accessibilityTap:", forControlEvents: .ValueChanged)
            
            let nsud = NSUserDefaults()
            
            // Checking the variable to retrieve the initial status of the switch.
            if nsud.objectForKey("accessibility") != nil {
                if sharedDefaults.accessibility {
                    accessibilitySwitch.on = true
                } else {
                    accessibilitySwitch.on = false
                }
            } else {
                sharedDefaults.accessibility = false
                accessibilitySwitch.on = false
            }
            
            cell.accessoryView = accessibilitySwitch
            
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier("TextCell", forIndexPath: indexPath)
        }
        
        cell.textLabel?.text = cellContent[indexPath.section][indexPath.row]
        cell.textLabel?.sizeToFit()
        
        return cell
    }
    
    // Handles highlighting the tableviewcells.
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.row == 0 && indexPath.section == 0 {
            return false
        }
        
        return true
    }
    
    // handling the clicks on the table items.
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            
            switch indexPath.row {
                
            case 0:
                sharedDefaults.accessibility = true
                
            // When the "Select Campus" item is clicked.
            case 1:
                self.performSegueWithIdentifier("ShowCampusSelectionViewController", sender: self)
                
            // Default action.
            default:
                print("NoSegueAvailable")
            }
        } else {
            switch indexPath.row {
            case 0:
                aboutTitle = "About"
            case 1:
                aboutTitle = "Terms of Service"
            case 2:
                aboutTitle = "Privacy Policy"
            default:
                aboutTitle = "Error"
            }
            
            self.performSegueWithIdentifier("ShowAboutViewController", sender: self)
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // Handling the tap on the accessibility switch.
    func accessibilityTap(sender: UISwitch!) {
        if sender.on {
            sharedDefaults.accessibility = true
            print(sharedDefaults.accessibility)
        } else {
            sharedDefaults.accessibility = false
            print(sharedDefaults.accessibility)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowAboutViewController" {
            let destinationSegue = segue.destinationViewController as! AboutViewController
            destinationSegue.title = aboutTitle
        }
    }
}