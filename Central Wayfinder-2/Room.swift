//
//  CampusLocation.swift
//  Central Wayfinder-2
//
//  Created by Lucas Angelon Arouca on 28/10/2015.
//  Copyright © 2015 Lucas Angelon Arouca. All rights reserved.
//

import Foundation

class Room: NSObject {
    
    var id: Int {
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
    
    var image: String {
        get {
            return self.image
        }
        
        set {
            self.image = newValue
        }
    }
    
    var buildingId: Int {
        get {
            return self.buildingId
        }
        
        set {
            self.buildingId = newValue
        }
    }
    
    var campusId: String {
        get {
            return self.campusId
        }
        
        set {
            self.campusId = newValue
        }
    }
    
    init(id: Int, name: String, image: String? = "", buildingId: Int, campusId: String) {
        super.init()
        
        self.id = id
        self.name = name
        
        // If the image variable is not empty, insert the value into the property.
        if (image != "") {
            self.image = image!
        } else {
            self.image = ""
        }
        
        self.buildingId = buildingId
        self.campusId = campusId
        
    }
}