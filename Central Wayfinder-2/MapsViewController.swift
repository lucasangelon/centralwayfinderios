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

// Based on: http://www.raywenderlich.com/90971/introduction-mapkit-swift-tutorial
// Based on: http://stackoverflow.com/questions/6495419/mkannotation-simple-example
// Based on: http://stackoverflow.com/questions/30867937/redundant-conformance-error-message-swift-2
// Based on: http://stackoverflow.com/questions/29764337/subclassing-mkannotation-error-conform-to-protocol

class MapsViewController : UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let regionRadius: CLLocationDistance = 9000000
    
    var destination: MapLocation!
    var start: MapLocation!
    var building: Building = Building()
    
    var locationManager: CLLocationManager = CLLocationManager()
    
    var userLat: CLLocationDegrees = 0.0
    var userLong: CLLocationDegrees = 0.0
    var userTitle = ""
    var destLat = 0.0
    var destLong = 0.0
    var destTitle = ""
    var destBuildingId = 0
    var initialLocation: CLLocation = CLLocation()
    var userLocation: CLLocation = CLLocation()
    
    var destinationItem: MKMapItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden = false
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        if destinationExists() {
            
        }
        
        /*if destinationExists() {
            createRoute(destBuildingId)
            let destinationLocation = CLLocation(latitude: destLat, longitude: destLong)
            
            centerMapOnLocation(destinationLocation)
            mapView?.addAnnotation(destination)
            mapView.addAnnotation(start)
        } else {
            centerMapOnLocation(initialLocation)
        }*/
        
        
    }
    
    // Sets the initial location for the user to the default if there are no location services or to the user's location.
    func setInitialLocation() {
        if checkLocationServices() {
            locationManager.startUpdatingLocation()
        } else {
            initialLocation = CLLocation(latitude: sharedDefaults.campusDefaultLat, longitude: sharedDefaults.campusDefaultLong)
        }
    }
    
    // Checks if the location services are on.
    func checkLocationServices() -> Bool {
        switch CLLocationManager.authorizationStatus() {
        case CLAuthorizationStatus.Restricted, CLAuthorizationStatus.Denied:
            
            // TODO: Alert about authorization.
            return false
        case CLAuthorizationStatus.NotDetermined:
            
            // TODO: Prompt acceptance.
            return false
        case CLAuthorizationStatus.Authorized, CLAuthorizationStatus.AuthorizedWhenInUse:
            return true
        }
    }
    
    // Checks if the application sent the user to this page with a destination from Services.
    func destinationExists() -> Bool {
        if destBuildingId != 0 {
            return true
        } else {
            return false
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    // Generating a route to be placed in the map.
    func createRoute(buildingId: Int) {
        
        building = sharedInstance.getBuilding(buildingId, building: building)
        
        // Set up the coordinates for the destination.
        destLat = building.lat
        destLong = building.long
        destination = MapLocation(coordinate: CLLocationCoordinate2D(latitude: destLat, longitude: destLong), title: destTitle, subtitle: "Destination")
        
        locationManager.startUpdatingLocation()

        // Set up the coordinates for the user.
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.Denied {
            userLat = sharedDefaults.campusDefaultLat
            userLong = sharedDefaults.campusDefaultLong
        } else {
            /*userLat = userLocation.coordinate.latitude
            print(userLocation.coordinate.longitude.description)
            print(mapView.userLocation.coordinate.latitude)
            userLong = userLocation.coordinate.longitude*/
        }
        
        userTitle = "You are here"
        start = MapLocation(coordinate: CLLocationCoordinate2D(latitude: userLat, longitude: userLong), title: "Title", subtitle: "Title")
        
        // Start a request.
        let request = MKDirectionsRequest()
        let markDestination = MKPlacemark(coordinate: CLLocationCoordinate2DMake(destLat, destLong), addressDictionary: nil)
        let markStart = MKPlacemark(coordinate: CLLocationCoordinate2DMake(userLat, userLong), addressDictionary: nil)
        
        // Define the request information.
        request.source = MKMapItem(placemark: markStart)
        request.destination = MKMapItem(placemark: markDestination)
        request.transportType = MKDirectionsTransportType.Automobile
        request.requestsAlternateRoutes = false
        
        let directions = MKDirections(request: request)
        
        
        // Pull the route information from the Apple Maps Request. Retrieved from: https://www.hackingwithswift.com/example-code/location/how-to-find-directions-using-mkmapview-and-mkdirectionsrequest
        directions.calculateDirectionsWithCompletionHandler { [unowned self] response, error in
            guard let unwrappedResponse = response else {
                return
            }
            
            for route in unwrappedResponse.routes {
                self.mapView.addOverlay(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
        
        locationManager.stopUpdatingLocation()
    }
    
    // Renders the route on the Map View.
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.blueColor().colorWithAlphaComponent(0.5)
        return renderer
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var locValue:CLLocation = locations.last!
        
        userLat = locValue.coordinate.latitude
        userLong = locValue.coordinate.longitude
        initialLocation = CLLocation(latitude: locValue.coordinate.latitude, longitude: locValue.coordinate.longitude)
        
        print("\(userLocation.coordinate.latitude) -> Lat \(userLocation.coordinate.longitude) -> Long")
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        switch status {
        case CLAuthorizationStatus.Restricted, CLAuthorizationStatus.Denied:
            initialLocation = CLLocation(latitude: sharedDefaults.campusDefaultLat, longitude: sharedDefaults.campusDefaultLong)
            // TODO: Alert about authorization.
            break
        case CLAuthorizationStatus.NotDetermined:
            initialLocation = CLLocation(latitude: sharedDefaults.campusDefaultLat, longitude: sharedDefaults.campusDefaultLong)
            // TODO: Prompt acceptance.
            break
        case CLAuthorizationStatus.Authorized, CLAuthorizationStatus.AuthorizedWhenInUse:
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        initialLocation = CLLocation(latitude: sharedDefaults.campusDefaultLat, longitude: sharedDefaults.campusDefaultLong)
    }
    
    func locationManagerDidPauseLocationUpdates(manager: CLLocationManager) {
        print("Finished")
    }
}
