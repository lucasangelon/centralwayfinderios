//
//  MapsViewController.swift
//  Central Wayfinder-2
//
//  Created by Lucas Angelon Arouca on 15/10/2015.
//  Copyright © 2015 Lucas Angelon Arouca. All rights reserved.
//

import UIKit

class GoogleMapsViewController : UIViewController {
    
    var didFindUserLocation = false
    
    var userLat = 0.0
    var userLong = 0.0
    var destLat = 0.0
    var destLong = 0.0
    var destTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: Remove, testing purposes.
        print(destLat)
        print(destLong)
    }
    
    // Generating a route to be placed in the map.
    func createRoute(dLat: Double, dLong: Double, dTitle: String) {
        
        // Set up the coordinates for the destination.
        destLat = dLat
        destLong = dLong
        destTitle = dTitle
    }
}
