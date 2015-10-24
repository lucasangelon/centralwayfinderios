//
//  MapsViewHelper.swift
//  Central Wayfinder-2
//
//  Created by Lucas Angelon Arouca on 15/10/2015.
//  Copyright © 2015 Lucas Angelon Arouca. All rights reserved.
//

import MapKit

extension MapsViewController {
    
    //TODO: Comment this D=
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        if let annotation = annotation as? MapLocation {
            
            let identifier = "pin"
            var view: MKPinAnnotationView
            
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
                as? MKPinAnnotationView {
                    // 2
                    dequeuedView.annotation = annotation
                    view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                
                // Changes the pin color to green for the starting position and red for destination.
                if (view.annotation?.subtitle)! == "Destination" {
                    if #available(iOS 9.0, *) {
                        view.pinTintColor = UIColor.redColor()
                    } else {
                        view.pinColor = MKPinAnnotationColor.Red
                    }
                } else {
                    if #available(iOS 9.0, *) {
                        view.pinTintColor = UIColor.greenColor()
                    } else {
                        view.pinColor = MKPinAnnotationColor.Green
                    }
                }
                
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure) as UIView
                
            }
            return view
        }
        return nil
    }
    
    // Handles the click on the detination information.
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
    }
}