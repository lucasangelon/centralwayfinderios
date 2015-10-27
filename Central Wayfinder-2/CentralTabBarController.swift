//
//  CentralTabBarController.swift
//  Central Wayfinder-2
//
//  Created by Lucas Angelon Arouca on 27/10/2015.
//  Copyright © 2015 Lucas Angelon Arouca. All rights reserved.
//

import Foundation
import UIKit

class CentralTabBarController : UITabBarController {
    
    let servicesVC = ServicesViewController()
    let settingsVC = SettingsViewController()
    
    public func setup() -> CentralTabBarController {
        let controllers = [servicesVC, settingsVC]
        
        self.viewControllers = controllers
        
        
        servicesVC.tabBarItem = UITabBarItem(
            title: "Pie",
            image: nil,
            tag: 1)

        
        return self
    }

}
