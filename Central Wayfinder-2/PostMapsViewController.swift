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
    
    private var roomName = String()
    
    private var building = Building()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var indoorMaps: UIButton!
    @IBOutlet weak var buildingNameLabel: UILabel!
    
    override func viewDidLoad() {
        self.navigationItem.title = roomName
        self.tabBarController?.tabBar.hidden = false
        
        imageView.image = sharedIndoorMaps.getBuildingImage()
        
        buildingNameLabel.text = sharedIndoorMaps.getBuildingName()
        buildingNameLabel.sizeToFit()
        
        indoorMaps.addTarget(self, action: "indoorMapsTap:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func indoorMapsTap(sender: UIButton) {
        performSegueWithIdentifier("ShowIndoorMapsViewController", sender: nil)
    }
    
    func setRoomName(roomName: String) {
        self.roomName = roomName
    }
}
