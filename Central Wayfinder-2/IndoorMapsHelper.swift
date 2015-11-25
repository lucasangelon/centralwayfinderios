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
    
    func reset() {
        self.indoorMaps = [IndoorMap]()
        self.buildingImage = UIImage()
    }
}