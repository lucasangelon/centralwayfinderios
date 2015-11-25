//
//  MapsViewHelper.swift
//  Central Wayfinder-2
//
//  Created by Lucas Angelon Arouca on 15/10/2015.
//  Copyright © 2015 Lucas Angelon Arouca. All rights reserved.
//

import MapKit


extension MapsViewController {
    
    // Adding the custom method for annotations on the map.
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        // Defining an annotation as a MapLocation.
        if let annotation = annotation as? MapLocation {
            
            // Creating an identifier and declaring a Pin.
            let identifier = "pin"
            var view: MKPinAnnotationView
            
            // Linking the identifier to the view.
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
                as? MKPinAnnotationView {

                    dequeuedView.annotation = annotation
                    view = dequeuedView
            } else {
                
                // Personalizing the view.
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                
                // Adding the information icon as well as the animation.
                view.canShowCallout = true
                view.animatesDrop = true
                
                // Changes the pin color to green for the starting position and red for destination.
                if (annotation.destination == true) {
                    setPinColor(view, color: UIColor.redColor(), annotationColor: MKPinAnnotationColor.Red)
                    
                    let button = UIButton(type: .DetailDisclosure)
                    
                    // Sets the building image to the button on the right side, rather small and
                    // not intuitive enough.
                    
                    //let image: UIImage = sharedIndoorMaps.getBuildingImage()
                    //button.setImage(image, forState: UIControlState.Normal)
                    //button.contentMode = .ScaleAspectFit
                    //button.frame = CGRectMake(0,0,40,40)
                    
                    // Adds the information button to the annotation.
                    view.rightCalloutAccessoryView = button
                    
                } else {
                    setPinColor(view, color: UIColor.greenColor(), annotationColor: MKPinAnnotationColor.Green)
                }
                
                // Ensuring the icon is placed properly on the information ballon.
                view.calloutOffset = CGPoint(x: -5, y: 5)
            }
            return view
        }
        return nil
    }
    
    func goToMaps(sender: MKPinAnnotationView) {
        performSegueWithIdentifier("ShowPostMapsViewController", sender: self)

    }
    
    // Handles the click on the destination information.
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            performSegueWithIdentifier("ShowPostMapsViewController", sender: self)
    }
    
    // Prepares to send the user to the location information page.
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowPostMapsViewController" {
            let destinationSegue = segue.destinationViewController as! PostMapsViewController
            destinationSegue.locationTitle = destSubtitle
            destinationSegue.postMapsInformation = self.postMapsInformation!
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