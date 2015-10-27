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
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if let annotation = annotation as? MapLocation {
            
            let identifier = "pin"
            var view: MKPinAnnotationView
            
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
                as? MKPinAnnotationView {

                    dequeuedView.annotation = annotation
                    view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                
                // Changes the pin color to green for the starting position and red for destination.
                if (view.annotation?.subtitle)! == "Destination" {
                    setPinColor(view, color: UIColor.redColor(), annotationColor: MKPinAnnotationColor.Red)
                    
                    // Adds the information button to the annotation.
                    view.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure) as UIView
                } else {
                    setPinColor(view, color: UIColor.greenColor(), annotationColor: MKPinAnnotationColor.Green)
                }
                
                view.calloutOffset = CGPoint(x: -5, y: 5)
            }
            return view
        }
        return nil
    }
    
    // Handles the click on the destination information.
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            performSegueWithIdentifier("ShowPostMapsViewController", sender: self)
    }
    
    // Prepares to send the user to the location information page.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowPostMapsViewController" {
            let destinationSegue = segue.destinationViewController as! PostMapsViewController
            destinationSegue.locationTitle = destination.title!
        }
    }
    
    // Handles the color of the pin annotations.
    private func setPinColor(view: MKPinAnnotationView, color: UIColor, annotationColor: MKPinAnnotationColor) {
        if #available(iOS 9.0, *) {
            view.pinTintColor = color
        } else {
            view.pinColor = annotationColor
        }
    }
}