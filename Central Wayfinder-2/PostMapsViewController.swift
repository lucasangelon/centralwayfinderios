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
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    var locationTitle: String = ""
    
    @IBOutlet weak var indoorMaps: UIButton!
    
    override func viewDidLoad() {
        navigationBar.title = locationTitle
        indoorMaps.addTarget(self, action: "indoorMapsTap:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowIndoorMapsViewController" {
            let destinationNavigationSegue = segue.destinationViewController as! UINavigationController
            let destinationSegue = destinationNavigationSegue.childViewControllers.first as! IndoorMapsViewController
            
            destinationSegue.locationTitle = locationTitle
        }
    }
    
    func indoorMapsTap(sender: UIButton) {
        performSegueWithIdentifier("ShowIndoorMapsViewController", sender: nil)
    }
}
