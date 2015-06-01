//
//  AddEventViewController.swift
//  SportLook
//
//  Created by Ibrahim Yildirim on 12/03/15.
//  Copyright (c) 2015 BachelorProject. All rights reserved.
//

import UIKit

class AddEventViewController: BaseViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    struct Static {
        static var gotLocationFromMap = false
        static var loc : CLLocationCoordinate2D?
        static var eventToEdit : Event?
    }
    
    //TO-DO update event in previous screen after updated
//    var eventToEdit : Event?
//    var editEvent : Bool?
    var eventId : Int?
    
    var categories = [Category]()
    
    var selectedDate : NSDate?
    var durationInSeconds : NSTimeInterval?
    var location : CLLocationCoordinate2D?
    
    var imagePicker : UIImagePickerController?
    var imagePicked : UIImage?
    var imageChanged : Bool = false
    var durationSelected : Bool = false

    @IBOutlet weak var slEventName : SLInputview!
    @IBOutlet weak var slEventCategory : SLInputview!
    @IBOutlet weak var slEventDate : SLInputview!
    @IBOutlet weak var slEventDuration : SLInputview!
    @IBOutlet weak var slEventAddress : SLInputview!
    @IBOutlet weak var txtDescription : UITextView!
    @IBOutlet weak var vwContentView : UIView!
    @IBOutlet weak var imgEvent: UIImageView!
    @IBOutlet weak var lblChangeEventImage: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        getCategories()
        
        if Static.eventToEdit != nil {
            self.title = "Edit Event"
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("editEventClicked"))
            self.setupEditEvent()
//            lblChangeEventImage.hidden = false
            lblChangeEventImage.hidden = true
        }
        else {
            self.title = "Add Event"
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("addEventClicked"))
            lblChangeEventImage.hidden = true
        }
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Stop, target: self, action: Selector("cancelClicked"))

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setupWidthOfContentView()
        
        if Static.gotLocationFromMap {
            
            Static.gotLocationFromMap = false
            
            if Static.loc != nil {
                self.getAddressFromLatLng(CLLocation(latitude: (Static.loc?.latitude)!, longitude: (Static.loc?.longitude)!))
                self.location = Static.loc
            }
            //Get address from Static.loc
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        imagePicker = UIImagePickerController()
    }
    
    init() {
        super.init(nibName: "AddEventViewController", bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Performing Requests
    func getCategories(){
        
        CategoryProvider.getCategories({ (categories) -> Void in
            
            println("Got Categories")
            self.categories = categories
            let categoryPicker = self.slEventCategory.txtField.inputView as! UIPickerView
            categoryPicker.reloadAllComponents()
            
            }, failure: { (error) -> Void in
                println("Error loading categories")
        })
    }
    
    func performAddEventRequest(){
    
        let e = getEventsFromFields()
        if e != nil {
            self.showLoading("Adding Event", delay: 0)
            
            EventProvider.addEvent(e!, success: { (event) -> Void in
                println("Event Added")
                
                if self.imageChanged {
                    self.eventId = event.id
                    
                    let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                    dispatch_async(dispatch_get_global_queue(priority, 0)) {
                        //Background Task
                        self.performUploadEventPictureRequest()
                        dispatch_async(dispatch_get_main_queue()) {
                            //UI Changes in main task
                            self.performSuccessActionAddEvent()
                        }
                    }
                }
                else {
                    self.performSuccessActionAddEvent()
                }

                //User subscribes to the event channel for Push notifications (for the Chat)
                let eventId = Constants.Parse.CHANNEL_EVENT + String((event.id)!)
                ParseChannelsHandler.subscribeToEventChannel(eventId)
                
                Constants.Load.setScreensToLoad()
                
            }, failure: { (error) -> Void in
                self.hideSpinner(0)
                let alert = SCLAlertView()
                alert.showError("Oups!", subTitle: "Failed to add event! Try again later.", closeButtonTitle: "Ok")
            })
        }
    }
    
    func performUpdateEventRequest() {
        let e = getEventsFromFields()
        
        if e != nil {
            self.showLoading("Updating event...", delay: 0)
            EventProvider.updateEvent(e!, success: { () -> Void in
                println("Edited Event")
                Static.eventToEdit = nil
                
                if self.imageChanged {
                    let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                    dispatch_async(dispatch_get_global_queue(priority, 0)) {
                        //Background Task
                        self.performUploadEventPictureRequest()
                        dispatch_async(dispatch_get_main_queue()) {
                            //UI Changes in main task
                            self.performSuccessActionAddEvent()
                        }
                    }
                }
                else {
                    self.performSuccessActionAddEvent()
                }
                
                Constants.Load.setScreensToLoad()
                
                }, failure: { (error) -> Void in
                self.hideSpinner(0)
                println("Error editting event")
                
            })
        }
    }
    
    func performUploadEventPictureRequest() {
        
        if(imagePicked != nil){
            let provider = UploadImageProvider()
            provider.uploadEventPicture(imagePicked!, eventId: String(eventId!), success: { (response) -> Void in
                    println("Uploaded event img")
                }) { (error) -> Void in
                    println("Failed to upload event img")
            }
        }
    }
    
    func performSuccessActionAddEvent(){
        
//        dispatch_async(dispatch_get_main_queue()) {
            self.hideSpinner(0)
            self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
//        }
    }
    
    func getEventsFromFields() -> Event? {
        
        let name = slEventName.txtField.text
        let category = slEventCategory.txtField.text
        let date = selectedDate;
        let address = slEventAddress.txtField.text
        let duration = durationInSeconds
        let description = txtDescription.text
        
        if(name.isEmpty || category.isEmpty || address.isEmpty || date == nil){
            
            let alert = SCLAlertView()
            alert.showError("Oups!", subTitle: "Input fields are not valid!", closeButtonTitle: "Ok")
            return nil
        }
        else {
            var e = Event()
            e.name = name
            
            if txtDescription.textColor != UIColor.lightGrayColor(){
                e.description = description
            }
            
            if location != nil {
                e.latitude = (location?.latitude)!
                e.longitude = (location?.longitude)!
            }
            e.address = address
            
            //Get Category by name
            var eventCategory : Category?
            for var i = 0; i < categories.count; i++ {
                if category == categories[i].name {
                    eventCategory = categories[i]
                }
            }
            
            if eventCategory != nil {
                e.category = eventCategory
            }
            
            
            e.startDate = date
            if duration != nil {
                e.endDate = date?.dateByAddingTimeInterval(duration!)
            }
            
            if eventId != nil {
                e.id = eventId
            }
            
            return e
        }
    }
    
    
    //MARK: UIBarButton clicks
    func addEventClicked()
    {
        performAddEventRequest()
    }
    
    func cancelClicked()
    {
        if Static.eventToEdit != nil {
            Static.eventToEdit = nil
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func editEventClicked()
    {
        performUpdateEventRequest()
    }
    
    //MARK: Picker
    func dateChanged() {
        
        var datePicker = slEventDate.txtField.inputView as! UIDatePicker
        let date = datePicker.date
        
        selectedDate = date
        self.updateSelectedDate(date)
    }
    
    func updateSelectedDate(date : NSDate){
        
        let df = NSDateFormatter()
        df.dateFormat = "EEE dd MMMM HH:mm"
        slEventDate.txtField.text = df.stringFromDate(date)
//        slEventDate.txtField.text = "\(self.getNameOfDay(weekDay)) \(dayOfMonth) \(monthName) at \(hour):\(minute)"
    }
    
    func durationChanged()
    {
        if !durationSelected {
            durationSelected = true
        }
        else {
            return
        }
        let durationPicker = slEventDuration.txtField.inputView as! UIDatePicker
        let seconds = durationPicker.countDownDuration
        durationInSeconds = seconds
        
        let hour = Int(seconds / 3600)
        let mins = Int((seconds % 3600) / 60)
        
        slEventDuration.txtField.text = "\(hour)h \(mins)m"
    }
    
    
    //MARK: Textfield delegate methods
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.tag == 104 {
            durationSelected = false
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        if textField.tag == 102 {
            let inputView = textField.inputView as! UIPickerView
            slEventCategory.txtField.text = self.categories[inputView.selectedRowInComponent(0)].name
        }
        
        //Tag 103 = Date TextField
        else if textField.tag == 103 {
            self.dateChanged()
        }
        
        //Tag 104 = Duration Textfield
        else if textField.tag == 104 {
            if durationSelected {
                self.durationChanged()
            }
        }
        
        else if textField.tag == 105 {
            if textField.text != ""{
                self.geoCodeUsingAddress(textField.text)
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        let nextTag = textField.tag + 1
        let nextResponder = self.view.viewWithTag(nextTag)
        
        if (nextResponder != nil) {
            nextResponder?.becomeFirstResponder()
        }
        else {
            textField.resignFirstResponder()
        }
        
        return false
    }
    
    //MARK: TextView Delegate Methods
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = nil
            textView.textColor = UIColor.COLOR_BLUE_DARK
        }
    }
    
    //MARK: Button Events 
    
    @IBAction func selectOnMapClicked(sender: AnyObject) {
        
        let controller = SelectOnMapViewController()
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    @IBAction func currentLocationClicked(sender: AnyObject) {
        
        self.showLoading("Getting Location", delay: 0)
        UserLocationHandler.getUserLocation({ (response) -> Void in
            
            dispatch_async(dispatch_get_main_queue()) {
                self.hideSpinner(0)
                self.updateEventLocation(response)
            }
            
            }, failure: { (error) -> Void in
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.hideSpinner(0)
                    let alert = SCLAlertView()
                    alert.showError("Oups!", subTitle: error.message, closeButtonTitle: "Ok")
                }
        })
    }
    
    func updateEventLocation(location : UserLocation)
    {
        slEventAddress.txtField.text = location.formattedAddress
        self.location = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
    }
    
    func getAddressFromLatLng(latLng : CLLocation) {
        
        let geoCoder = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(latLng, completionHandler: { (placeMarks, error) -> Void in
//            println(placeMarks)
            if placeMarks != nil {
            
                let place = placeMarks[0] as! CLPlacemark
                
                if place.thoroughfare != nil {
                    var s : String
                    if place.subThoroughfare != nil {
                        s = String(format : "%@ %@, %@ %@", place.thoroughfare, place.subThoroughfare, place.postalCode, place.locality)
                    }
                    else {
                        s = String(format : "%@, %@ %@", place.thoroughfare, place.postalCode, place.locality)
                    }
                    self.slEventAddress.txtField.text = s
                }
                else {
                    self.slEventAddress.txtField.text = "Error getting address from maps"
                }
                
            }
        })
        
    }
    
    //MARK: Picker Delegate Methods
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return categories[row].name
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        slEventCategory.txtField.text = categories[row].name
    }
    
    //MARK: Private methods
    func setupEditEvent() {
        
        let event = Static.eventToEdit
        
        slEventName.txtField.text = event?.name
        slEventCategory.txtField.text = event?.category?.name
        slEventAddress.txtField.text = event?.address
        
        self.selectedDate = event?.startDate
        self.updateSelectedDate((event?.startDate)!)
        
        eventId = event?.id
        
        if event?.description != nil {
            txtDescription.text = event?.description
            txtDescription.textColor = UIColor.COLOR_BLUE_DARK
        }
    }
    
    func setupWidthOfContentView(){
        
        let screen = UIScreen.mainScreen().bounds
//        println("Width: \(screen.size.width) Height: \(screen.size.height)")
        
        var constW = NSLayoutConstraint(item: vwContentView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: screen.size.width)
        vwContentView.addConstraint(constW)
    }
    
    func setupLayout()
    {
        slEventName.setTextField("Event Name", keyboardType: UIKeyboardType.Default, image: UIImage(named: "ic_name"), returnKey: UIReturnKeyType.Next)
        slEventName.txtField.tag = 101
        slEventName.txtField.delegate = self
        
        slEventCategory.setTextField("Category", keyboardType: nil, image: UIImage(named: "ic_name"), returnKey: UIReturnKeyType.Next)
        slEventCategory.txtField.tag = 102
        slEventCategory.txtField.delegate = self
        let categoryPicker = UIPickerView()
        categoryPicker.delegate = self
        slEventCategory.txtField.inputView = categoryPicker
        
        slEventDate.setTextField("Date", keyboardType: nil, image: UIImage(named: "ic_date"), returnKey: UIReturnKeyType.Next)
        slEventDate.txtField.tag = 103
        slEventDate.txtField.delegate = self
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = UIDatePickerMode.DateAndTime
        datePicker.addTarget(self, action: Selector("dateChanged"), forControlEvents: UIControlEvents.ValueChanged)
        slEventDate.txtField.inputView = datePicker
        
        slEventDuration.setTextField("Duration (Optional)", keyboardType: UIKeyboardType.Default, image: UIImage(named: "ic_date"), returnKey: UIReturnKeyType.Next)
        slEventDuration.txtField.tag = 104
        slEventDuration.txtField.delegate = self
        slEventDuration.txtField.clearButtonMode = UITextFieldViewMode.Always
        let datePickerDuration = UIDatePicker()
        datePickerDuration.datePickerMode = UIDatePickerMode.CountDownTimer
        datePickerDuration.addTarget(self, action: Selector("durationChanged"), forControlEvents: UIControlEvents.ValueChanged)
        slEventDuration.txtField.inputView = datePickerDuration
        
        slEventAddress.setTextField("Address, city, zip", keyboardType: nil, image: UIImage(named: "ic_location"), returnKey: UIReturnKeyType.Done)
        slEventAddress.txtField.tag = 105
        slEventAddress.txtField.delegate = self
        
        txtDescription.delegate = self
        txtDescription.text = "Enter event description"
        txtDescription.textColor = UIColor.lightGrayColor()
        txtDescription.font = UIFont(name: UIFont.QUICKSAND_REGULAR, size: 14)
    }
    
    func geoCodeUsingAddress(address : String) {
        var latitude : Double = 0
        var longitude : Double = 0

        let geoCoder = CLGeocoder()
        var center = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        
        geoCoder.geocodeAddressString(address, completionHandler: { (placeMarks, error) -> Void in
            
            if placeMarks != nil {
                let placeMark = placeMarks.last as! CLPlacemark
                
                center = CLLocationCoordinate2D(latitude: placeMark.location.coordinate.latitude, longitude: placeMark.location.coordinate.longitude)
                self.location = center
                println("Got Location")
            }
            else {
                println("Error getting latitude")
                let alert = SCLAlertView()
                alert.showError("Oups!", subTitle: "Error to find the address in map, did you enter correct information? Try using \"Select on Map\" or \"My Location\" make sure you entered correct address.", closeButtonTitle: "Ok")
            }
        })
    }
    
    //MARK: Event image methods
    
    @IBAction func btnEventImageTapped(sender: UIButton) {
        
//        //Remove function select event image
//        return
        
        println("btnEventImageTapped")
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){
            
            imagePicker!.delegate = self
            imagePicker!.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
            imagePicker!.allowsEditing = false
            
            self.presentViewController(imagePicker!, animated: true, completion: nil)
        }

    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
        imgEvent.image = image
        imgEvent.contentMode = UIViewContentMode.ScaleAspectFill
        imagePicked = image
        imageChanged = true
    }
}
