//
//  SettingsViewController.swift
//  Central Wayfinder-2
//
//  Created by Lucas Angelon Arouca on 15/10/2015.
//  Copyright © 2015 Lucas Angelon Arouca. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    // List items for the menu.
    let cellContent = [["Accessibility", "Select Campus"], ["About", "Terms of Service", "Copyright"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TextCell", forIndexPath: indexPath)
        
        cell.textLabel?.text = cellContent[indexPath.section][indexPath.row]
        
        return cell
    }
    
    // handling the clicks on the table items.
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
            
        // When the "Select Campus" item is clicked.
        case 1:
            self.performSegueWithIdentifier("ShowCampusSelectionViewController", sender: self)
            
        // Default action.
        default:
            print("NoSegueAvailable")
        }
    }
}

