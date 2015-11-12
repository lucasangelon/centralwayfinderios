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
    var postMapsInformation = [String]()
    
    @IBOutlet weak var indoorMaps: UIButton!
    @IBOutlet weak var buildingNameLabel: UILabel!
    @IBOutlet weak var roomLocationLabel: UILabel!
    
    override func viewDidLoad() {
        self.navigationItem.title = locationTitle
        
        buildingNameLabel.text = locationTitle
        buildingNameLabel.sizeToFit()
        
        roomLocationLabel.text = "PLEEease"//postMapsInformation[0]
        roomLocationLabel.sizeToFit()
        
        indoorMaps.addTarget(self, action: "indoorMapsTap:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func indoorMapsTap(sender: UIButton) {
        performSegueWithIdentifier("ShowIndoorMapsViewController", sender: nil)
    }
}
