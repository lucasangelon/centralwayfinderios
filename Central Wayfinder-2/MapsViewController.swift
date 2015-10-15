//
//  MapsViewController.swift
//  Central Wayfinder-2
//
//  Created by Lucas Angelon Arouca on 15/10/2015.
//  Copyright © 2015 Lucas Angelon Arouca. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MapsViewController : UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var didFindUserLocation = false
    var destination: MapLocation!
    
    var userLat = 0.0
    var userLong = 0.0
    var destLat = 0.0
    var destLong = 0.0
    var destTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: Remove, testing purposes.
        print(destLat)
        print(destLong)
        
        let initialLocation = CLLocation(latitude: -31.948085, longitude: 115.861103)
        
        mapView.delegate = self
        if destinationExists() {
            let destinationLocation = CLLocation(latitude: destLat, longitude: destLong)
            
            centerMapOnLocation(destinationLocation)
            mapView?.addAnnotation(destination)
            
        } else {
            centerMapOnLocation(initialLocation)
        }
    }
    
    
    let regionRadius: CLLocationDistance = 600
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    // Generating a route to be placed in the map.
    func createRoute(dLat: Double, dLong: Double, dTitle: String) {
        
        // Set up the coordinates for the destination.
        destLat = dLat
        destLong = dLong
        destTitle = dTitle
        destination = MapLocation(coordinate: CLLocationCoordinate2D(latitude: dLat, longitude: dLong), title: dTitle, subtitle: dTitle)
    }
    
    func destinationExists() -> Bool {
        if destLat != 0.0 && destLong != 0.0 {
            return true
        } else {
            return false
        }
    }
}
