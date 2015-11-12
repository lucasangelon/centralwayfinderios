//
//  CentralWebController.swift
//  Central Wayfinder-2
//
//  Created by Lucas Angelon Arouca on 12/11/2015.
//  Copyright © 2015 Lucas Angelon Arouca. All rights reserved.
//

import Foundation
import UIKit

class CentralWebViewController: UIViewController {
    
    var notificationCenter = NSNotificationCenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Open the browser and go to central.wa.edu.au
        let url = NSURL(string: "http://central.wa.edu.au")!
        UIApplication.sharedApplication().openURL(url)
        
        notificationCenter.addObserver(self, selector: ":applicationIsActive", name: UIApplicationDidBecomeActiveNotification, object: nil)
    }
    
    @IBAction func applicationIsActive(sender: NSNotification) {
        if self.tabBarController?.selectedViewController == self {
            self.tabBarController?.selectedIndex = 0
        }
        
        notificationCenter.removeObserver(self)
    }
}
