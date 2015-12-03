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

@available(iOS 8.0, *)
class MapsViewController : UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    /*
     *  Table, Segmented Controls and Activity Indicator declarations.
     */
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var directionsTypeControl: UISegmentedControl!
    
    @IBOutlet weak var mapTypeControl: UISegmentedControl!
    
    /*
     *  Map Declarations.
     */
    
    @IBOutlet weak var mapView: MKMapView!

    private final let regionRadius: CLLocationDistance = 375
    
    private var destination: MapLocation!
    private var start: MapLocation!
    private let locationManager = CLLocationManager()
    private let application = UIApplication.sharedApplication()
    var building: Building?
    
    // User Information
    private var userTitle = ""
    
    // Destination Information
    var destSubtitle = ""
    
    // Locations
    private var initialLocation = CLLocationCoordinate2D()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden = false        
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor(red: (236/255), green: (104/255), blue: (36/255), alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.title = "Maps"
        
        //Set Map Type Control Action
        self.mapTypeControl.addTarget(self, action: "mapTypeToggle:", forControlEvents: UIControlEvents.ValueChanged)
        self.directionsTypeControl.addTarget(self, action: "directionsTypeToggle:", forControlEvents: UIControlEvents.ValueChanged)
        
        /* Map Section */
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        mapView.delegate = self
        
        setUpMaps()
    }
    
    // Centers map on a given location. Used to set the default zoom for campuses.
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    // Sets up the page / refreshes it.
    private func setUpMaps() {
        
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        
        self.view.bringSubviewToFront(activityIndicator)
        
        let application = UIApplication.sharedApplication()
        application.beginIgnoringInteractionEvents()
        
        // If the user was sent here from another page with data.
        if destinationExists() {
            
            // Deletes images in the web service.
            deleteImages()
            
            // Generates the route.
            generateRoute(building!.id, directionsType: MKDirectionsTransportType.Walking)
            
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
            start = MapLocation(coordinate: initialLocation, title: "Your Location", subtitle: "Default Campus Location", destination: false)
            mapView.addAnnotation(start)
            mapView.selectAnnotation(start, animated: true)
            mapView.showAnnotations([start], animated: true)
        }
        
        centerMapOnLocation(CLLocation(latitude: sharedDefaults.campusDefaultLat, longitude: sharedDefaults.campusDefaultLong))
    }
    
    // Sets the initial location for the user to the default if there are no location services.
    // Creates the start object for the MKDirections Request.
    private func setInitialLocation() {
        initialLocation = CLLocationCoordinate2D(latitude: sharedDefaults.campusDefaultLat, longitude: sharedDefaults.campusDefaultLong)
    }
    
    // Checks if the location services are on.
    private func checkLocationServices() -> Bool {
        switch CLLocationManager.authorizationStatus() {
        case CLAuthorizationStatus.Restricted, CLAuthorizationStatus.Denied:
            return false
        case CLAuthorizationStatus.NotDetermined:
            return false
        case CLAuthorizationStatus.Authorized, CLAuthorizationStatus.AuthorizedWhenInUse:
            return true
        }
    }
    
    // Checks if the application sent the user to this page with a destination from Services.
    private func destinationExists() -> Bool {
        if building!.id != 0 {
            return true
        } else {
            return false
        }
    }
    
    /*
     * Generates a route for the mapView.
     */
    private func generateRoute(buildingId: Int, directionsType: MKDirectionsTransportType) {
        
        // Creates the destination object.
        destination = MapLocation(coordinate: CLLocationCoordinate2D(latitude: building!.lat, longitude: building!.long), title: building!.name, subtitle: destSubtitle, destination: true)
        
        // Start a request for maps.
        let request = MKDirectionsRequest()
        
        // If location services are enabled.
        if checkLocationServices() {
            
            // Define the required data for the annotations on the map.
            let markDestination = MKPlacemark(coordinate: CLLocationCoordinate2DMake(destination.coordinate.latitude, destination.coordinate.longitude), addressDictionary: nil)
            
            // Define the request information.
            request.source = MKMapItem.mapItemForCurrentLocation()
            request.destination = MKMapItem(placemark: markDestination)
            request.transportType = directionsType
            request.requestsAlternateRoutes = false
            
            mapView.showsUserLocation = true

        } else {
            
            // Sets the default location.
            setInitialLocation()
            
            // Sets the start object for the route.
            start = MapLocation(coordinate: initialLocation, title: "Your Location", subtitle: "You are here", destination: false)
            
            // Define the required data for the annotations on the map.
            let markDestination = MKPlacemark(coordinate: CLLocationCoordinate2DMake(destination.coordinate.latitude, destination.coordinate.longitude), addressDictionary: nil)
            let markStart = MKPlacemark(coordinate: CLLocationCoordinate2DMake(start.coordinate.latitude, start.coordinate.longitude), addressDictionary: nil)
            
            // Define the request information.
            request.source = MKMapItem(placemark: markStart)
            request.destination = MKMapItem(placemark: markDestination)
            request.transportType = directionsType
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
        
        self.activityIndicator.hidden = true
        application.endIgnoringInteractionEvents()
    }
    
    /*
     * Location Manager Functions
     */
    
    // Renders the route on the Map View.
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.blueColor().colorWithAlphaComponent(0.5)
        return renderer
    }
    
    // Upon change of the authorization status.
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
    
    // Runs once the locationManager has updated the user's location.
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        
        let userLocation: CLLocation = locations[locations.count - 1] as CLLocation
        
        initialLocation = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
    }
    
    // In case an error occurrs while pulling the locationManager coordinates.
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error.localizedDescription)
    }
    
    // Map Type Toggle handler.
    func mapTypeToggle(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.mapView.mapType = MKMapType.Standard
        case 1:
            self.mapView.mapType = MKMapType.Satellite
        case 2:
            self.mapView.mapType = MKMapType.Hybrid
        default:
            break
        }
    }
    
    // Directions Type Toggle handler.
    func directionsTypeToggle(sender: UISegmentedControl) {
        clearRoute()
        
        switch sender.selectedSegmentIndex {
        case 0:
            generateRoute(building!.id, directionsType: MKDirectionsTransportType.Walking)
        case 1:
            generateRoute(building!.id, directionsType: MKDirectionsTransportType.Automobile)
        default:
            break
        }
    }
    
    // Clears the current route from the map.
    private func clearRoute() {
        let overlays = mapView.overlays
        mapView.removeOverlays(overlays)
    }
    
    private func deleteImages() {
        let dispatchQueue = dispatch_get_main_queue()
        dispatch_async(dispatchQueue) {
            let webServicesHelper = WebServicesHelper()
            let indoorMaps = sharedIndoorMaps.getIndoorMapsURLs()
            webServicesHelper.purgeIndoorMap(indoorMaps)
        }
    }
}