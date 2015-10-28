
//
//  Waypoint.swift
//  Central Wayfinder-2
//
//  Created by Lucas Angelon Arouca on 28/10/2015.
//  Copyright © 2015 Lucas Angelon Arouca. All rights reserved.
//

import Foundation

class Waypoint: NSObject {
    
    var id: Int = Int()
    var buildingId: Int = Int()
    var floorId: Int = Int()
    var waypointIdPrev: Int = Int()
    var waypointIdPrevDis: Int = Int()
    var coordinateX: Double = Double()
    var coordinateY: Double = Double()
    var roomName: String = String()
    var transitionMode: String = String()
}