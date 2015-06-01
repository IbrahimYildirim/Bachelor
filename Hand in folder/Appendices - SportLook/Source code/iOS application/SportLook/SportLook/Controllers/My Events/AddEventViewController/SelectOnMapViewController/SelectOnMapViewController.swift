//
//  SelectOnMapViewController.swift
//  SportLook
//
//  Created by Ibrahim Yildirim on 30/03/15.
//  Copyright (c) 2015 BachelorProject. All rights reserved.
//

import UIKit
import MapKit

class SelectOnMapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var vwSelectLocation : UIView!
    
    var locationSelected = false
    var location : CLLocationCoordinate2D?
    var updatedLocation = false
    var annotation : MKPointAnnotation?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Select on Map"
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Stop, target: self, action: Selector("cancelClicked"))
        
        
        let longPressGest = UILongPressGestureRecognizer(target: self, action: Selector("dropPin:"))
        longPressGest.minimumPressDuration = 1.0 //hold it for 1 second
        self.mapView.addGestureRecognizer(longPressGest)
    }
    
    init() {
        super.init(nibName: "SelectOnMapViewController", bundle: nil)
   
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectLocationClicked(sender: AnyObject) {
        AddEventViewController.Static.gotLocationFromMap = true
        AddEventViewController.Static.loc = location!
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    //MARK: UIBarButton clicks    
    func cancelClicked()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func dropPin(gestureRecognizer : UIGestureRecognizer) {
        if gestureRecognizer.state != UIGestureRecognizerState.Began {
            return
        }
        
        let point = gestureRecognizer.locationInView(self.mapView)
        let pointOnMap = self.mapView.convertPoint(point, toCoordinateFromView: self.mapView)
        
        let anno = MKPointAnnotation()
        anno.coordinate = pointOnMap
        self.mapView.addAnnotation(anno)
        
        self.location = CLLocationCoordinate2D(latitude: pointOnMap.latitude, longitude: pointOnMap.longitude)
        if !locationSelected {
            self.fadeIn(vwSelectLocation)
        }

        if self.annotation != nil {
            self.mapView.removeAnnotation(annotation)
        }
        annotation = anno
        locationSelected = true
        
    }
    
    //MARK: MKMapView Delegate Function
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
        if !updatedLocation{
            let region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800)
            self.mapView.setRegion(region, animated: true)
            updatedLocation = true
        }
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if annotation is MKUserLocation {
            // return nil so map view draws "blue dot" for standard user location
            return nil
        }
        else {
            
            var annotationView : MKPinAnnotationView?
            annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier("pin") as? MKPinAnnotationView
            
            if (annotationView == nil) {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            }
            annotationView?.image = UIImage(named: "pin")
            return annotationView
        }
    }
    
}
