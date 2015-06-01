//
//  SearchEventsViewController.swift
//  SportLook
//
//  Created by Ibrahim Yildirim on 06/03/15.
//  Copyright (c) 2015 BachelorProject. All rights reserved.
//

import UIKit
import MapKit


class SearchEventsViewController: BaseViewController, MKMapViewDelegate, KPClusteringControllerDelegate, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {

    struct Static {
        static var filterEvents = false
        static var showAllEvents = true
        static var filteredCategories = [Category]()
    }
    
    @IBOutlet weak var tblEvents: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var vwEventInfo : UIView!
    @IBOutlet weak var lblInfoCategory: UILabel!
    @IBOutlet weak var lblInfoName: UILabel!
    @IBOutlet weak var lblInfoDate: UILabel!
    @IBOutlet weak var vwClusterInfo: UIView!
    
    
    var allEvents : [Event]!
    private var allAnnotations : [KPAnnotation]!
    private var clusteringController : KPClusteringController!
    private var selectedEvent : Event!
    private var selectedAnnotation : KPAnnotation!
    private var showEventInfo : Bool = false
    private var locationShowed : Bool = false
    private var clickedOnCluster : Bool = false
    private var clusterEvents = [Event]()
    var locationManager = CLLocationManager()
    
    
    //MARK: Utilities
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Find Events"
        self.setCustomBackButton()
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.rotateEnabled = false
        
//        self.locationManager.delegate = self
//        self.locationManager.requestWhenInUseAuthorization()
        
        let algorithm = KPGridClusteringAlgorithm()
        algorithm.annotationSize = CGSizeMake(25,50)
        algorithm.clusteringStrategy = KPGridClusteringAlgorithmStrategy.TwoPhase
        
        self.clusteringController = KPClusteringController(mapView: self.mapView)
        clusteringController.delegate = self
        
        vwEventInfo.layer.shadowOffset = CGSize(width: 0, height: 0)
        vwEventInfo.layer.borderColor = UIColor.COLOR_BLUE_DARK.CGColor
        
        let filterButton = UIBarButtonItem(title: String.fontAwesomeIconWithName(FontAwesome.Filter), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("filterClicked"))
        filterButton.setTitleTextAttributes(NSDictionary(dictionary: [NSFontAttributeName:UIFont.fontAwesomeOfSize(25), NSForegroundColorAttributeName : UIColor.COLOR_BLUE_DARK]) as [NSObject : AnyObject], forState: UIControlState.Normal)

        self.navigationItem.rightBarButtonItem = filterButton
        
        let nibName = UINib(nibName: "ClusterEventTableViewCell", bundle: nil)
        tblEvents.registerNib(nibName, forCellReuseIdentifier: ClusterEventTableViewCell.description())
        
    }
    
    init() {
        super.init(nibName: "SearchEventsViewController", bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if Constants.Load.shouldLoad("search") {
            self.showLoading("Loading Events", delay: 0)
            EventProvider.getEvents({ (events) -> Void in
                println("Got: \(events.count) events")
                self.allEvents = events
                self.clusteringController.setAnnotations(self.annotations())
                self.hideSpinner(0)
                }, failure: { (error) -> Void in
                    println("Failed getting events")
                    self.hideSpinner(0)
            })
        }
        
        if Static.filterEvents {
            if Static.showAllEvents {
                self.clusteringController.setAnnotations(self.annotations())
            }
            else if Static.filteredCategories.count >= 1 {
                self.clusteringController.setAnnotations(self.filterAnnotations(Static.filteredCategories))
            }
            self.clusteringController.refresh(true)
        }
        
        if showEventInfo {
            self.fadeViewAway(vwEventInfo)
            showEventInfo = false
        }
        
        locationManager.startUpdatingLocation()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        locationManager.stopUpdatingLocation()
    }
    
    //MARK: Filter Events 
    func filterClicked(){
        if allEvents == nil {
            return;
        }
        let controller = FilterEventsViewController()
        let navController = UINavigationController(rootViewController: controller)
        controller.allEvents = self.allEvents
        self.navigationController?.presentViewController(navController, animated: true, completion: nil)
    }
    
    //MARK: Private Methods
    func showTableWithEvents(annotations : [KPAnnotation]){
        
        var eventsToBeShown = [Event]()
        
        for anno in annotations {
            for e in allEvents {
                if e.latitude == anno.coordinate.latitude && e.longitude == anno.coordinate.longitude {
                    if !eventsToBeShown.contains(e){
                        eventsToBeShown.append(e)
                    }
                }
            }
        }
        self.clusterEvents = eventsToBeShown
        tblEvents.reloadData()
        self.scaleViewUp(vwClusterInfo)
    }
    
    func updateEventView(){
        
        if selectedEvent != nil {
            if selectedEvent.category?.name != nil {
                self.lblInfoCategory.text = "#\((selectedEvent.category?.name)!)"
            } else {
                self.lblInfoCategory.text = "#Category"
            }
            self.lblInfoName.text = selectedEvent.name
            
            let calander = NSCalendar.currentCalendar()
            let components = calander.components(NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitDay | NSCalendarUnit.CalendarUnitHour | NSCalendarUnit.CalendarUnitMinute | NSCalendarUnit.CalendarUnitWeekday, fromDate: selectedEvent.startDate!)
            
            let df = NSDateFormatter()
            df.dateFormat = "EEE dd MMMM HH:mm"
            
            self.lblInfoDate.text = df.stringFromDate(selectedEvent.startDate!)
            
        }
    }
    
    func updateUserLocation(location : CLLocation){
        ProfileProvider.updateUserLocation(location, success: { () -> Void in
            println("Location Updated")
            }) { (error) -> Void in
                println("Failed to update Location")
        }
    }
    
    @IBAction func moreInfoClicked(sender: AnyObject) {
        
        if selectedEvent != nil {
            let ctrlEventInfo = EventInfoViewController()
            ctrlEventInfo.eventId = selectedEvent.id
            self.navigationController?.pushViewController(ctrlEventInfo, animated: true)
        }
    }
    
    //MARK: UITableView Methods
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tblEvents.dequeueReusableCellWithIdentifier(ClusterEventTableViewCell.description(), forIndexPath: indexPath) as! ClusterEventTableViewCell
        
        let event = clusterEvents[indexPath.row]
        cell.lblName.text = event.name
        cell.lblCategory.text = event.category?.name
        
        let df = NSDateFormatter()
        df.dateFormat = "EEE dd MMMM HH:mm"
        cell.lblDate.text = df.stringFromDate(event.startDate!)
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clusterEvents.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let ctrl = EventInfoViewController()
        ctrl.event = clusterEvents[indexPath.row]
        self.navigationController?.pushViewController(ctrl, animated: true)
    }
    
    //MARK: MapView Delegate Methods
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
        
        if !locationShowed {
            let loc = userLocation.coordinate;
            let region = MKCoordinateRegionMakeWithDistance(loc, 1500, 1500)
            self.mapView.setRegion(region, animated: true)
            
            locationShowed = true
        }
        
        //Check if it should update users location
        let defaults = NSUserDefaults.standardUserDefaults()
        if (defaults.objectForKey("lastLocationUpdate") != nil) {
            let lastUpdateDate = defaults.objectForKey("lastLocationUpdate") as! NSDate
            let currentDate = NSDate()
            
            let nextUpdate = lastUpdateDate.addDays(1)
//            let nextUpdate = lastUpdateDate.addHours(0.1)
            
            if currentDate.isGreaterThanDate(nextUpdate){
                println("Update the shit")
                self.updateUserLocation(userLocation.location)
                defaults.setValue(NSDate(), forKey: "lastLocationUpdate")
            }
        }
        else if defaults.objectForKey("lastLocationUpdate") == nil {
            println("update for first time")
            self.updateUserLocation(userLocation.location)
            defaults.setValue(NSDate(), forKey: "lastLocationUpdate")
        }
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedWhenInUse {
            self.mapView.showsUserLocation = true
        }
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if annotation is MKUserLocation {
            // return nil so map view draws "blue dot" for standard user location
            return nil
        }
        
        var annotationView : MKPinAnnotationView?
        
        if annotation is KPAnnotation {
            let a : KPAnnotation = annotation as! KPAnnotation
            
            if a.isCluster() {
                
                annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier("cluster") as? MKPinAnnotationView
                
                if (annotationView == nil) {
                    annotationView = MKPinAnnotationView(annotation: a, reuseIdentifier: "cluster")
                }
                
                switch a.annotations.count {
                    case 2 : annotationView?.image = UIImage(named: "pin2")
                    case 3 : annotationView?.image = UIImage(named: "pin3")
                    case 4 : annotationView?.image = UIImage(named: "pin4")
                    case 5 : annotationView?.image = UIImage(named: "pin5")
                    case 6 : annotationView?.image = UIImage(named: "pin6")
                    case 7 : annotationView?.image = UIImage(named: "pin7")
                    case 8 : annotationView?.image = UIImage(named: "pin8")
                    case 9 : annotationView?.image = UIImage(named: "pin9")
                    default : annotationView?.image = UIImage(named: "pin10")
                    
                }
            }
                
            else {
                annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier("pin") as? MKPinAnnotationView
                
                if (annotationView == nil) {
                    annotationView = MKPinAnnotationView(annotation: a, reuseIdentifier: "pin")
                }
                annotationView?.image = UIImage(named: "pin")
            }
        }
        
        return annotationView;
    }
    
    func mapView(mapView: MKMapView!, regionDidChangeAnimated animated: Bool) {
        clusteringController.refresh(true)
        
        if showEventInfo {
            self.updateEventView()
            self.scaleViewUp(vwEventInfo)
        }
        
        let annoSet = mapView.annotationsInMapRect(mapView.visibleMapRect)
        let annoArray = Array(annoSet)//Swift 1.2 change
//        let annoArray = annoSet.allObjects
        if annoSet.count == 1 {
            for var i = 0; i < annoArray.count; i++ {
                let anno = annoArray[i] as? KPAnnotation
                if anno == nil {
                    break
                }
                if (anno?.isCluster())! {
    
                    let span = self.mapView.region.span
                    if span.latitudeDelta < 0.005 && span.longitudeDelta < 0.005 {
                        if clickedOnCluster {
                            //Move view a bit down and show tableview
                            let center = CLLocationCoordinate2D(latitude: (anno?.coordinate.latitude)! + 0.0010, longitude: (anno?.coordinate.longitude)!);
                            let viewRegion = MKCoordinateRegionMake(center, MKCoordinateSpanMake(0.003, 0.003))
                            self.mapView.setRegion(viewRegion, animated: true)
                            
//                            self.showTableWithEvents(anno?.annotations.allObjects as [KPAnnotation])
                            self.showTableWithEvents(Array(arrayLiteral: anno?.annotations) as! [KPAnnotation]) //Swift 1.2 change
                        }
                    }
                }
            }
        }
        self.clickedOnCluster = false
    }
    
    func mapView(mapView: MKMapView!, regionWillChangeAnimated animated: Bool) {
        
        if showEventInfo {
            self.fadeViewAway(vwEventInfo)
            showEventInfo = false
            
            if selectedAnnotation != nil{
                self.mapView.deselectAnnotation(self.selectedAnnotation, animated: true)
            }
        }
        
        if !vwClusterInfo.hidden {
            self.fadeViewAway(vwClusterInfo)
        }
    }
    
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        if view.annotation is KPAnnotation {
            let cluster : KPAnnotation = view.annotation as! KPAnnotation
            
            if !vwEventInfo.hidden {
                return
            }
            
            
            
            if cluster.annotations.count > 1 {
                let region = MKCoordinateRegionMakeWithDistance(cluster.coordinate,
                    cluster.radius * 2.5,
                    cluster.radius * 2.5)
                
                mapView.setRegion(region, animated: true)
                self.clickedOnCluster = true
            }
            else {
                let center = CLLocationCoordinate2D(latitude: cluster.coordinate.latitude + 0.0010, longitude: cluster.coordinate.longitude);

                let viewRegion = MKCoordinateRegionMake(center, MKCoordinateSpanMake(0.003, 0.003))
                self.mapView.setRegion(viewRegion, animated: true)
                
                for var i = 0; i < allAnnotations.count; i++ {
                    let a = allAnnotations[i]
                    if a.coordinate.latitude == cluster.coordinate.latitude && a.coordinate.longitude == cluster.coordinate.longitude {
                        selectedEvent = allEvents[i]
                        break
                    }
                }
                
                selectedAnnotation = cluster
                showEventInfo = true
            }
        }
    }
    
    //MARK: KingPin Delegate Methods
//    func clusteringControllerShouldClusterAnnotations(clusteringController: KPClusteringController!) -> Bool {
//        let span = self.mapView.region.span
//        
//        if span.latitudeDelta > 0.004 && span.longitudeDelta > 0.005{
//            return true
//        }
//        else {
//            return false
//        }
//    }
    
    
    func annotations() -> [KPAnnotation] {
        allAnnotations = [KPAnnotation]()
        var annotations: [KPAnnotation] = []
        
        let dkCoord: CLLocationCoordinate2D = self.dkCoord()
        
        if (self.allEvents != nil) {
            for var i = 0; i < allEvents?.count; i++ {
                let event : Event = allEvents[i]
                
                var coordinate : CLLocationCoordinate2D
                if event.latitude != nil || event.longitude != nil {
                    coordinate = CLLocationCoordinate2D(latitude:event.latitude, longitude: event.longitude)
                }
                else {
                    //Put randomly annotation in Denmark for testing
                    let latAdj: Double = ((Double(random()) % 1000) / 1000.0)
                    let lngAdj: Double = ((Double(random()) % 1000) / 1000.0)

                    coordinate = CLLocationCoordinate2D(latitude: dkCoord.latitude + latAdj, longitude:dkCoord.longitude + lngAdj )
                }
                
                let cord: KPAnnotation = KPAnnotation()
                cord.coordinate = coordinate
                self.allAnnotations.append(cord)
                annotations.append(cord)
            }
        }
        return annotations
    }
    
    func filterAnnotations(filter : [Category]) -> [KPAnnotation] {
        
        var filteredAnnotations = [KPAnnotation]()
        
        if (self.allEvents != nil) {
            for e in self.allEvents {
                
                if filter.contains(e.category!){
                    var coordinate : CLLocationCoordinate2D
                    if e.latitude != nil || e.longitude != nil {
                        coordinate = CLLocationCoordinate2D(latitude: e.latitude, longitude: e.longitude)
                        
                        let cord = KPAnnotation()
                        cord.coordinate = coordinate
                        filteredAnnotations.append(cord)
                    }
                }
            }
        }
        
        return filteredAnnotations
    }
    
    func dkCoord() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(55.15, 9.35)
    }
    
    //MARK: Animations 
    func scaleViewUp(view : UIView!)
    {
        if view.hidden{
            view.hidden = false
            view.alpha = 0
        }
        
        let fadeAnimation : POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        fadeAnimation.toValue = 1
        fadeAnimation.duration = 0.2
        view.pop_addAnimation(fadeAnimation, forKey: "fadeAnim")
        
        let scaleAnimation : POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
        scaleAnimation.springSpeed = 12
        scaleAnimation.springBounciness = 12
        scaleAnimation.fromValue = NSValue(CGSize: CGSize(width: 0, height: 0))
        view.layer.pop_addAnimation(scaleAnimation, forKey: "scaleUp");
    }
    
    func fadeViewAway(view : UIView!)
    {
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            view.alpha = 0
            }, completion: { (finished) -> Void in
                view.hidden = true
                view.alpha = 1
        })
    }
}
