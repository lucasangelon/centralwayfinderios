//
//  PostMapsViewController.swift
//  Central Wayfinder-2
//
//  Created by Lucas Angelon Arouca on 24/10/2015.
//  Copyright © 2015 Lucas Angelon Arouca. All rights reserved.
//

import Foundation
import UIKit

class PostMapsViewController : UIViewController {
    
    var locationTitle: String = ""
    
    @IBOutlet weak var indoorMaps: UIButton!
    
    override func viewDidLoad() {
        self.navigationItem.title = locationTitle
        indoorMaps.addTarget(self, action: "indoorMapsTap:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func indoorMapsTap(sender: UIButton) {
        performSegueWithIdentifier("ShowIndoorMapsViewController", sender: nil)
    }
}
