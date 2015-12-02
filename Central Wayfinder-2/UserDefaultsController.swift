//
//  UserDefaultsController.swift
//  Central Wayfinder-2
//
//  Created by Lucas Angelon Arouca on 23/10/2015.
//  Copyright © 2015 Lucas Angelon Arouca. All rights reserved.
//

import Foundation

let sharedDefaults = UserDefaultsController()

class UserDefaultsController {
    
    private let defaults = NSUserDefaults.standardUserDefaults()
    
    // Getters and Setters
    // Campus Id
    var campusId: String {
        get {
            return defaults.stringForKey("selectedCampus")!
        }
        
        set {
            defaults.setObject(newValue, forKey: "selectedCampus")
        }
    }
    
    // Campus Name
    var campusName: String {
        get {
            return defaults.stringForKey("selectedCampusName")!
        }
        
        set {
            defaults.setObject(newValue, forKey: "selectedCampusName")
        }
    }
    
    // Campus Default Latitude
    var campusDefaultLat: Double {
        get {
            return defaults.doubleForKey("campusLat")
        }
        
        set {
            defaults.setDouble(newValue, forKey: "campusLat")
        }
    }
    
    // Campus Default Longitude
    var campusDefaultLong: Double {
        get {
            return defaults.doubleForKey("campusLong")
        }
        
        set {
            defaults.setDouble(newValue, forKey: "campusLong")
        }
    }
    
    // Campus Version
    var campusVersion: Int {
        get {
            return defaults.integerForKey("campusVersion")
        }
        
        set {
            defaults.setInteger(newValue, forKey: "campusVersion")
        }
    }
    
    // Accessibility
    var accessibility: Bool {
        get {
            return defaults.boolForKey("accessibility")
        }
        
        set {
            defaults.setBool(newValue, forKey: "accessibility")
        }
    }
    
    // First Launch Detector
    var isFirstLaunch: Bool {
        get {
            return defaults.boolForKey("isFirstLaunch")
        }
        
        set {
            defaults.setBool(newValue, forKey: "isFirstLaunch")
        }
    }
}