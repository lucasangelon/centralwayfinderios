//
//  Building.swift
//  Central Wayfinder-2
//
//  Created by Lucas Angelon Arouca on 28/10/2015.
//  Copyright © 2015 Lucas Angelon Arouca. All rights reserved.
//

import Foundation

class Building: NSObject {
    
    var id: Int = Int()
    init(id: Int) {
        self.id = id
    }
    
    var name: String = String()
    init(name: String) {
        self.name = name
    }
    
    var lat: Double = Double()
    init(lat: Double) {
        self.lat = lat
    }
    
    var long: Double = Double()
    init(long: Double) {
        self.long = long
    }
    
    var campusId: String = String()
    init(campusId: String) {
        self.campusId = campusId
    }
    
    init(id: Int, name: String, lat: Double, long: Double, campusId: String) {
        super.init()
        
        self.id = id
        self.name = name
        self.lat = lat
        self.long = long
        self.campusId = campusId
    }
    
    override init() {
        super.init()
    }
}