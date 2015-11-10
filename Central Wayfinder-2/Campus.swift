//
//  Campus.swift
//  Central Wayfinder-2
//
//  Created by Lucas Angelon Arouca on 28/10/2015.
//  Copyright © 2015 Lucas Angelon Arouca. All rights reserved.
//

import Foundation

class Campus: NSObject {
    
    var id: String = String()
    init(id: String) {
        self.id = id
    }
    
    var name: String = String()
    init(name: String) {
        self.name = name
    }
    
    var version: Int = Int()
    init(version: Int) {
        self.version = version
    }
    
    var lat: Double = Double()
    init(lat: Double) {
        self.lat = lat
    }
    
    var long: Double = Double()
    init(long: Double) {
        self.long = long
    }
    
    var zoom: Double = Double()
    init(zoom: Double) {
        self.zoom = zoom
    }
    
    init(id: String, name: String, version: Int, lat: Double, long: Double, zoom: Double) {
        super.init()
        
        self.id = id
        self.name = name
        self.version = version
        self.lat = lat
        self.long = long
        self.zoom = zoom
    }
    
    override init() {
        super.init()
    }
}