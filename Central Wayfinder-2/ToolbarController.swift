//
//  ToolbarController.swift
//  Central Wayfinder-2
//
//  Created by Lucas Angelon Arouca on 27/10/2015.
//  Copyright © 2015 Lucas Angelon Arouca. All rights reserved.
//

import Foundation
import UIKit

class ToolbarController : UINavigationController {
    
    public func getBasicItems() -> [UIBarButtonItem] {
        
        
        let menuItem = UIBarButtonItem(barButtonSystemItem: .Play, target: self, action: "barButtonItemClicked:")
        menuItem.tag = 1
        
        let servicesItem = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "barButtonItemClicked:")
        servicesItem.tag = 2
        
        let webItem = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "barButtonItemClicked:")
        webItem.tag = 3
        
        let settingsItem = UIBarButtonItem(barButtonSystemItem: .Trash, target: self, action: "barButtonItemClicked:")
        settingsItem.tag = 4
        
        let flexItem = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        
        let toolbarButtonItems = [menuItem, flexItem, servicesItem, flexItem, webItem, flexItem, settingsItem]
        
        return toolbarButtonItems
    }
    
    func barButtonItemClicked(sender: UIBarButtonItem) {
        let tag = sender.tag
        
        switch tag {
        case 1:
            if #available(iOS 8.0, *) {
                self.performSegueWithIdentifier("ToolbarToServices", sender: self.navigationController?.viewControllers)
            } else {
                // Fallback on earlier versions
            }
        case 2:
            self.popToViewController(ServicesViewController(), animated: true)
        case 3:
            return
        case 4:
            self.performSegueWithIdentifier("ToolbarToSettings", sender: self.navigationController)
        default:
            return
        }
    }
}
