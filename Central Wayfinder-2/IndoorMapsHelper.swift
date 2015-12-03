//  IndoorMapsHelper.swift
//  Central Wayfinder-2
//
//  Created by Lucas Angelon Arouca on 20/11/2015.
//  Copyright © 2015 Lucas Angelon Arouca. All rights reserved.
//

import Foundation
import UIKit

let sharedIndoorMaps = IndoorMapsHelper()

class IndoorMapsHelper : NSObject {
    private var indoorMaps = [IndoorMap]()
    private var buildingImage = UIImage()
    private let imageLoader = ImageLoader()
    private var building = Building()
    private var indoorMapUrls = [String]()
    private let basePath = "C:\\\\Inetpub\\\\vhosts\\\\student.mydesign.central.wa.edu.au\\\\httpdocs\\\\cf_Wayfinding_WebService\\\\/Img/"
    private let indoorBreaker = "/Img/"
    
    func downloadBuildingImage(url: String) {
        imageLoader.imageForUrl(url, completionHandler: {
            (image: UIImage?, url: String) in
            self.buildingImage = image!
        })
    }
    
    func downloadIndoorMap(url: String, title: String) {
        imageLoader.imageForUrl(url, completionHandler: {
            (image: UIImage?, url: String) in
            self.indoorMaps.append(IndoorMap(image: image!, title: title, imagePath: url))
        })
    }
    
    func stringBreaker(path: String) -> String {
        return path
    }
    
    func getBuildingName() -> String {
        return self.building.name
    }
    
    func setBuilding(building: Building) {
        self.building = building
    }
    
    func getBuilding() -> Building {
        return self.building
    }
    
    func setBuildingImage(buildingImage: UIImage) {
        self.buildingImage = buildingImage
    }
    
    func getBuildingImage() -> UIImage {
        return self.buildingImage
    }
    
    func setIndoorMaps(indoorMaps: [IndoorMap]) {
        self.indoorMaps = indoorMaps
    }
    
    func getIndoorMaps() -> [IndoorMap] {
        return self.indoorMaps
    }
    
    func appendIndoorMapUrl(var url: String) {
        
        var finalUrl = String()
        
        if url != "" {
            url = url.componentsSeparatedByString(indoorBreaker)[1]
            finalUrl = basePath + url
        } else {
            finalUrl = "http://central.wa.edu.au/Style%20Library/CIT.Internet.Branding/images/Central-Institute-of-Technology-logo.gif"
        }
        
        self.indoorMapUrls.append(finalUrl)
    }
    
    func getIndoorMapsURLs() -> [String] {
        return self.indoorMapUrls
    }
    
    func reset() {
        self.indoorMaps = [IndoorMap]()
        self.buildingImage = UIImage()
        self.indoorMapUrls = [String]()
    }
}