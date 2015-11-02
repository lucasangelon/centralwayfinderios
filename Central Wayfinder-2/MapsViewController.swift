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
    
    var destination: MapLocation!
    var start: MapLocation!
    var building: Building = Building()
    var locationManager = CLLocationManager()
    
    var userLat = 0.0
    var userLong = 0.0
    var userTitle = ""
    var destLat = 0.0
    var destLong = 0.0
    var destTitle = ""
    var initialLocation: CLLocation = CLLocation()
    
    var destinationItem: MKMapItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make the navigation bar visible after the main menu view controller.
        self.navigationController?.navigationBarHidden = false
        

        
        initialLocation = CLLocation(latitude: sharedDefaults.campusDefaultLat, longitude: sharedDefaults.campusDefaultLong)
        
        mapView.delegate = self
        
        if destinationExists() {
            let destinationLocation = CLLocation(latitude: destLat, longitude: destLong)
            
            centerMapOnLocation(destinationLocation)
            mapView?.addAnnotation(destination)
            mapView.addAnnotation(start)
        } else {
            centerMapOnLocation(initialLocation)
        }
    }
    
    
    let regionRadius: CLLocationDistance = 300
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    // Generating a route to be placed in the map.
    func createRoute(roomName: String, buildingId: Int
        ) {
        
        building = sharedInstance.getBuilding(buildingId, building: building)
        
        // Set up the coordinates for the destination.
        destLat = building.lat
        destLong = building.long
        destTitle = roomName
        destination = MapLocation(coordinate: CLLocationCoordinate2D(latitude: destLat, longitude: destLong), title: destTitle, subtitle: "Destination")
        
        // Set up the coordinates for the user.
        userLat = sharedDefaults.campusDefaultLat
        userLong = sharedDefaults.campusDefaultLong
        userTitle = "You are here"
        start = MapLocation(coordinate: CLLocationCoordinate2D(latitude: userLat, longitude: userLong), title: userTitle, subtitle: "Your Location")
        
        // Start a request.
        let request = MKDirectionsRequest()
        let markDestination = MKPlacemark(coordinate: CLLocationCoordinate2DMake(userLat, userLong), addressDictionary: nil)
        let markStart = MKPlacemark(coordinate: CLLocationCoordinate2DMake(destLat, destLong), addressDictionary: nil)
        
        // Define the request information.
        request.source = MKMapItem(placemark: markStart)
        request.destination = MKMapItem(placemark: markDestination)
        request.transportType = MKDirectionsTransportType.Walking
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
    }
    
    // Renders the route on the Map View.
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.blueColor().colorWithAlphaComponent(0.5)
        return renderer
    }
    
    // Checks if the application sent the user to this page with a destination from Services.
    func destinationExists() -> Bool {
        if destLat != 0.0 && destLong != 0.0 {
            return true
        } else {
            return false
        }
    }
    
    // Gets the user location through Location Services.
    /*func getUserLocation() -> [Double] {
        if #available(iOS 8.0, *) {
            if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
                CLLocationManager.startUpdatingLocation(locationManager)
            }
        } else {
            // Fallback on earlier versions
        }
    }*/
    
    /*func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLat = locations.
    }*/
}
