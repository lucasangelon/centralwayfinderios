//
//  Campus.swift
//  Central Wayfinder-2
//
//  Created by Lucas Angelon Arouca on 28/10/2015.
//  Copyright © 2015 Lucas Angelon Arouca. All rights reserved.
//

import Foundation

class Campus: NSObject {
    
    var id: String {
        get {
            return self.id
        }
        
        set {
            self.id = newValue
        }
    }
    
    var name: String {
        get {
            return self.name
        }
        
        set {
            self.name = newValue
        }
    }
    
    var lat: Double {
        get {
            return self.lat
        }
        
        set {
            self.lat = newValue
        }
    }
    
    var long: Double {
        get {
            return self.long
        }
        
        set {
            self.long = newValue
        }
    }
    
    var zoom: Double {
        get {
            return self.zoom
        }
        
        set {
            self.zoom = newValue
        }
    }
    
    init(id: String, name: String, lat: Double, long: Double, zoom: Double) {
        super.init()
        
        self.id = id
        self.name = name
        self.lat = lat
        self.long = long
        self.zoom = zoom
    }
    
    
}