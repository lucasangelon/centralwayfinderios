//
//  IndoorMapsViewController.swift
//  Central Wayfinder-2
//
//  Created by Lucas Angelon Arouca on 24/10/2015.
//  Copyright © 2015 Lucas Angelon Arouca. All rights reserved.
//

import Foundation
import UIKit

class IndoorMapsViewController : UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    private var indoorMaps = [IndoorMap]()
    private var imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor(red: (236/255), green: (104/255), blue: (36/255), alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        // Sets the images to the objects.
        setMaps()
        
        // Granting this view controller access to the scrollView events.
        scrollView.delegate = self
        
        // Adding the action to the segmented control, handles the image swap.
        segmentedControl.addTarget(self, action: "segmentedControlChange:", forControlEvents: UIControlEvents.ValueChanged)
        
        // Defaults to the first image of the array.
        imageView = UIImageView(image: indoorMaps[0].image)
        imageView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: imageView.image!.size)
        
        // Adding the image to the scrollView and settings its size.
        scrollView.addSubview(imageView)
        scrollView.contentSize = imageView.image!.size
        
        // Generating the zoom action (pinch or double-click).
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: "scrollViewDoubleTapped:")
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.numberOfTouchesRequired = 1
        scrollView.addGestureRecognizer(doubleTapRecognizer)
        
        // Defining the zoom properties for the scrollView.
        scrollView.minimumZoomScale = 0.25
        scrollView.maximumZoomScale = 2.0
        scrollView.zoomScale = 0.00025
        
        // Centers the image on the screen.
        centerImage()
    }
    
    // Handles the image swap.
    func segmentedControlChange(sender: UISegmentedControl) {
        
        // Reset the zoom.
        scrollView.zoomScale = 0.00025
        imageView.image = indoorMaps[sender.selectedSegmentIndex].image
    }
    
    // Handles the double tap.
    func scrollViewDoubleTapped(recognizer: UITapGestureRecognizer) {
        
        // Retrieves the exact coordinates a user has clicked on the screen.
        let pointInView = recognizer.locationInView(scrollView)
        
        // Updating the zoom.
        var newZoomScale = scrollView.zoomScale * 1.4
        newZoomScale = min(newZoomScale, scrollView.maximumZoomScale)
        
        // Defining the values for the rectangle to be zoomed to.
        let scrollViewSize = scrollView.bounds.size
        let w = scrollViewSize.width / newZoomScale
        let h = scrollViewSize.height / newZoomScale
        let x = pointInView.x - (w / 2.0)
        let y = pointInView.y - (h / 2.0)
        
        // Zoom to the specified rectangle.
        let rectToZoomTo = CGRectMake(x, y, w, h);
        scrollView.zoomToRect(rectToZoomTo, animated: true)
    }
    
    // Centers the image.
    func centerImage() {
        
        // Getting the max size of the scrollView.
        let boundsSize = scrollView.bounds.size
        
        // Actual imageView size.
        var contentsFrame = imageView.frame
        
        if contentsFrame.size.width < boundsSize.width {
            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0
        } else {
            contentsFrame.origin.x = 0.0
        }
        
        if contentsFrame.size.height < boundsSize.height {
            contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0
        } else {
            contentsFrame.origin.y = 0.0
        }
        
        // Sets the updated frame.
        imageView.frame = contentsFrame
    }
    
    // Sets up the images.
    func setMaps() {
        indoorMaps = [IndoorMap]()
        indoorMaps = sharedIndoorMaps.getIndoorMaps().reverse()
        
        segmentedControl.removeAllSegments()
        
        for index in (0..<indoorMaps.count) {
            
            // Adds a segment with the map name (split from the base string)
            // and the image to be added to the scrollView.
            segmentedControl.insertSegmentWithTitle(indoorMaps[index].title.componentsSeparatedByString(",")[1], atIndex: index, animated: true)
        }
    }
    
    // Subview to be used for the zooming action.
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    // Whenever the scrollView receives a pinch, center the image.
    func scrollViewDidZoom(scrollView: UIScrollView) {
        centerImage()
    }
}
