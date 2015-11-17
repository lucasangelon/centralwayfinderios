//
//  CentralTabBarController.swift
//  Central Wayfinder-2
//
//  Created by Lucas Angelon Arouca on 13/11/2015.
//  Copyright © 2015 Lucas Angelon Arouca. All rights reserved.
//

import Foundation
import UIKit

class CentralTabBarController : UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        self.delegate = self
    }
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        if item.title == "Central Web" {
            
            // Open the browser and go to central.wa.edu.au
            let url = NSURL(string: "http://central.wa.edu.au")!
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
/*    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {

    }*/
    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {

        if viewController == tabBarController.viewControllers![2] {
            return false
        } else {
            return true
        }
    }
}
