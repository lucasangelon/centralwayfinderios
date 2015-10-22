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

class MapsViewController : UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var didFindUserLocation = false
    var destination: MapLocation!
    var start: MapLocation!
    
    var userLat = 0.0
    var userLong = 0.0
    var userTitle = ""
    var destLat = 0.0
    var destLong = 0.0
    var destTitle = ""
    
    var destinationItem: MKMapItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let initialLocation = CLLocation(latitude: -31.948085, longitude: 115.861103)
        
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
        
        // Set up the coordinates for the user.
        userLat = -31.9470712
        userLong = 115.855008
        userTitle = "Oliver's on James"
        start = MapLocation(coordinate: CLLocationCoordinate2D(latitude: userLat, longitude: userLong), title: userTitle, subtitle: userTitle)
        
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
        renderer.strokeColor = UIColor.blueColor()
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
}
