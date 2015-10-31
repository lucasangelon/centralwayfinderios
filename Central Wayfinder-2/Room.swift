//
//  CampusLocation.swift
//  Central Wayfinder-2
//
//  Created by Lucas Angelon Arouca on 28/10/2015.
//  Copyright © 2015 Lucas Angelon Arouca. All rights reserved.
//

import Foundation

class Room: NSObject {
    
    var id: Int = Int()
    init(id: Int) {
        self.id = id
    }
    
    var name: String = String()
    init(name: String) {
        self.name = name
    }
    
    var image: String = String()
    init(image: String) {
        self.image = image
    }
    
    var buildingId: Int = Int()
    init(buildingId: Int) {
        self.buildingId = buildingId
    }
    
    var campusId: String = String()
    init(campusId: String) {
        self.campusId = campusId
    }
    
    init(id: Int, name: String, image: String? = "", buildingId: Int, campusId: String) {
        super.init()
        
        self.id = id
        self.name = name
        
        // If the image variable is not empty, insert the value into the property.
        if (image != "NoImage") {
            self.image = image!
        } else {
            self.image = "NoImage"
        }
        
        self.buildingId = buildingId
        self.campusId = campusId
    }
    
    override init() {
        super.init()
    }
}