//
//  MapLocation.swift
//  Central Wayfinder-2
//
//  Created by Lucas Angelon Arouca on 15/10/2015.
//  Copyright © 2015 Lucas Angelon Arouca. All rights reserved.
//

import Foundation
import MapKit

class MapLocation : NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var destination: Bool?
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String, destination: Bool) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        self.destination = destination
    }
}
