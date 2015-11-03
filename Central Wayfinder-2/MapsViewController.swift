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
    
    let regionRadius: CLLocationDistance = 300
    
    var destination: MapLocation!
    var start: MapLocation!
    var building: Building = Building()
    let locationManager = CLLocationManager()
    
    // User Information
    var userTitle = ""
    
    // Destination Information
    var destTitle = ""
    var destBuildingId = 0
    
    // Locations
    var initialLocation = CLLocationCoordinate2D()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden = false
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.startUpdatingLocation()
        
        mapView.delegate = self
        
        // If the user was sent here from another page with data.
        if destinationExists() {
            
            // Generates the route.
            generateRoute(destBuildingId)
            
            if start != nil {
                mapView.addAnnotation(start)
            }
            mapView.addAnnotation(destination)
            
            // Centers the map between the start and destination positions.
            if start != nil {
                mapView.showAnnotations([start, destination], animated: true)
            } else {
                mapView.showAnnotations([MKMapItem.mapItemForCurrentLocation().placemark, destination], animated: true)
            }
            
            mapView.selectAnnotation(destination, animated: true)
        } else {
            // Sets the default initial location.
            setInitialLocation()
            
            // Set a default location, center and select it.
            start = MapLocation(coordinate: initialLocation, title: "Your Location", subtitle: "You are here")
            mapView.addAnnotation(start)
            mapView.selectAnnotation(start, animated: true)
            mapView.showAnnotations([start], animated: true)
        }
    }
    
    // Sets the initial location for the user to the default if there are no location services.
    // Creates the start object for the MKDirections Request.
    func setInitialLocation() {
        initialLocation = CLLocationCoordinate2D(latitude: sharedDefaults.campusDefaultLat, longitude: sharedDefaults.campusDefaultLong)
    }
    
    // Checks if the location services are on.
    func checkLocationServices() -> Bool {
        switch CLLocationManager.authorizationStatus() {
        case CLAuthorizationStatus.Restricted, CLAuthorizationStatus.Denied:
            print("Restricted or Denided")
            // TODO: Alert about authorization.
            return false
        case CLAuthorizationStatus.NotDetermined:
            print("Indetermined")
            // TODO: Prompt acceptance.
            return false
        case CLAuthorizationStatus.Authorized, CLAuthorizationStatus.AuthorizedWhenInUse:
            print("Authorized or AuthorizedWhenInUse")
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
    
    // Runs once the locationManager has updated the user's location.
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        
        let userLocation: CLLocation = locations[locations.count - 1] as CLLocation

        initialLocation = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        
        print("\(userLocation.coordinate.latitude) -> Lat \(userLocation.coordinate.longitude) -> Long")
    }
    
    // In case an error occurrs while pulling the locationManager coordinates.
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error.localizedDescription)
    }
    
    /*
     * Generates a route for the mapView.
     */
    func generateRoute(buildingId: Int) {
        
        // Retrieves the building from the database.
        building = sharedInstance.getBuilding(buildingId, building: building)
        
        // Creates the destination object.
        destination = MapLocation(coordinate: CLLocationCoordinate2D(latitude: building.lat, longitude: building.long), title: destTitle, subtitle: "Destination")
        
        // Start a request for maps.
        let request = MKDirectionsRequest()
        
        // If location services are enabled.
        if checkLocationServices() {
            
            // Define the required data for the annotations on the map.
            let markDestination = MKPlacemark(coordinate: CLLocationCoordinate2DMake(destination.coordinate.latitude, destination.coordinate.longitude), addressDictionary: nil)
            
            // Define the request information.
            request.source = MKMapItem.mapItemForCurrentLocation()
            request.destination = MKMapItem(placemark: markDestination)
            request.transportType = MKDirectionsTransportType.Any
            request.requestsAlternateRoutes = false
            
            mapView.showsUserLocation = true

        } else {
            
            // Sets the default location.
            setInitialLocation()
            
            // Sets the start object for the route.
            start = MapLocation(coordinate: initialLocation, title: "Your Location", subtitle: "You are here")
            
            // Define the required data for the annotations on the map.
            let markDestination = MKPlacemark(coordinate: CLLocationCoordinate2DMake(destination.coordinate.latitude, destination.coordinate.longitude), addressDictionary: nil)
            let markStart = MKPlacemark(coordinate: CLLocationCoordinate2DMake(start.coordinate.latitude, start.coordinate.longitude), addressDictionary: nil)
            
            // Define the request information.
            request.source = MKMapItem(placemark: markStart)
            request.destination = MKMapItem(placemark: markDestination)
            request.transportType = MKDirectionsTransportType.Any
            request.requestsAlternateRoutes = false
        }
        
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
    }
    
    // Renders the route on the Map View.
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.blueColor().colorWithAlphaComponent(0.5)
        return renderer
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        switch status {
        case CLAuthorizationStatus.Restricted, CLAuthorizationStatus.Denied:
            initialLocation = CLLocationCoordinate2D(latitude: sharedDefaults.campusDefaultLat, longitude: sharedDefaults.campusDefaultLong)
            // TODO: Alert about authorization.
            break
        case CLAuthorizationStatus.NotDetermined:
            initialLocation = CLLocationCoordinate2D(latitude: sharedDefaults.campusDefaultLat, longitude: sharedDefaults.campusDefaultLong)
            // TODO: Prompt acceptance.
            break
        case CLAuthorizationStatus.Authorized, CLAuthorizationStatus.AuthorizedWhenInUse:
            locationManager.stopUpdatingLocation()
        }
    }
}
