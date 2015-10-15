//
//  MapsViewController.swift
//  Central Wayfinder-2
//
//  Created by Lucas Angelon Arouca on 15/10/2015.
//  Copyright © 2015 Lucas Angelon Arouca. All rights reserved.
//

import UIKit
import GoogleMaps

class GoogleMapsViewController : UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: GMSMapView!
    
    let locationManager = CLLocationManager()
    var didFindUserLocation = false
    
    var userLat = 0.0
    var userLong = 0.0
    var destLat = 0.0
    var destLong = 0.0
    var destTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let camera = GMSCameraPosition.cameraWithLatitude(destLat, longitude: destLong, zoom: 1)
        mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        self.view = mapView
        
        mapView.addObserver(self, forKeyPath: "userLocation", options: NSKeyValueObservingOptions.New, context: nil)
        
        let originMarker = GMSMarker()
        
        // If service locations are enabled, retrieve the user's location.
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        // If the user's location was retrieved.
        if (userLat != 0.0 && userLong != 0.0) {
            originMarker.position = CLLocationCoordinate2DMake(userLat, userLong)
            originMarker.title = "You are here."
            originMarker.map = mapView
        }
        
        let destMarker = GMSMarker()
        destMarker.position = CLLocationCoordinate2DMake(destLat, destLong)
        destMarker.title = destTitle
        destMarker.map = mapView
        
        // TODO: Remove, testing purposes.
        print(destLat)
        print(destLong)
    }
    
    // Generating a route to be placed in the map.
    func createRoute(dLat: Double, dLong: Double, dTitle: String) {
        
        // Set up the coordinates for the destination.
        destLat = dLat
        destLong = dLong
        destTitle = dTitle
    }
    
    // Getting the user's location.
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        
        userLat = locationManager.location!.coordinate.latitude
        userLong = locationManager.location!.coordinate.longitude
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        if #available(iOS 8.0, *) {
            if status == CLAuthorizationStatus.AuthorizedWhenInUse {
                mapView.myLocationEnabled = true
            }
        } else {
            // Fallback on earlier versions
        }
    }
}
