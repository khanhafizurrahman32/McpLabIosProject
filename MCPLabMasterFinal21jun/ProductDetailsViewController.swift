//
//  ProductDetailsViewController.swift
//  MCPLabLogin
//
//  Created by Khan hafizur rahman on 6/15/16.
//  Copyright © 2016 Khan hafizur rahman. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import CoreData

class ProductDetailsViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,CLLocationManagerDelegate, MKMapViewDelegate, UITextFieldDelegate {


    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var productName: UITextField!
    
    @IBOutlet weak var amountNumber: UITextField!
    
    @IBOutlet weak var otherInformation: UITextField!
    
    @IBOutlet weak var Categories: UIPickerView!
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager ()
    
    var productNameValue: String = ""

    
    var amountNumberValue = ""
    
    var otherInformationValue = ""
    
    var categoryListArray = ["Study","cloth","food"]
    
    var categorySelected = ""
    
    var productStorage = [NSManagedObject]()
    
    var latitude = ""
    
    var longitude = ""
    
    var selectedPin:MKPlacemark? = nil
    
    var myLocation = CLLocationCoordinate2D(latitude: 0.0, longitude:  0.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //viewString = "false"
        // Map portion as an input
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        self.locationManager.startUpdatingLocation()
        
        
        self.otherInformation.delegate = self
        
        self.productName.delegate = self
        
        self.amountNumber.delegate = self
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            //self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.revealViewController().panGestureRecognizer()
        }
        
        
        
        //self.mapView.delegate = self
        
        //self.mapView.mapType = MKMapType.Standard
        
        /*let Aachen = CLLocationCoordinate2D(latitude: 50.774362, longitude: 6.088964)
         self.mapView.region = MKCoordinateRegionMakeWithDistance(Aachen, 1000, 1000)*/
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: myLocation, span: span)
        
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            self.locationManager.requestWhenInUseAuthorization()
        }else if CLLocationManager.authorizationStatus() != .AuthorizedWhenInUse {
            UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
        }
        
        
        
        /*if CLLocationManager.locationServicesEnabled (){
         self.locationManager.startUpdatingLocation()
         }*/
        
        // category drop down box
        Categories.delegate = self
        Categories.dataSource = self
        
        
        
        
        /*if self.revealViewController() != nil {
         menuButton.target = self.revealViewController()
         menuButton.action = "revealToggle:"
         self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
         }*/

    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        /*let viewControllers = self.navigationController?.viewControllers
         for viewController in viewControllers! {
         print(viewController)
         
         }
         //let viewController = viewControllers! [(viewControllers?.count)!]
         print("viewController \(viewControllers?.count)")*/
        
        productName.text = NSUserDefaults.standardUserDefaults().stringForKey("submitProductNameValue")
        amountNumber.text = NSUserDefaults.standardUserDefaults().stringForKey("submitAmountNumberValue")
        otherInformation.text = NSUserDefaults.standardUserDefaults().stringForKey("submitOtherInfoValue")
        
        
    }
    
    func textFieldDidChange(productName:UITextField){
        productNameValue = productName.text!
        NSUserDefaults.standardUserDefaults().setObject(productNameValue,forKey: "submitProductNameValue")
    }
    
    func amountNumberTextFieldChange(amountNumber:UITextField){
        print("insideamountNumberTextFieldChange")
        NSUserDefaults.standardUserDefaults().setObject(amountNumber.text!,forKey: "submitAmountNumberValue")
    }
    
    func otherInfoTextFieldChange(otherInformation:UITextField){
        print("insideOtherInfoTextFieldChange")
        print(NSDate())
        NSUserDefaults.standardUserDefaults().setObject(otherInformation.text!, forKey: "submitOtherInfoValue")
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryListArray[row]
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryListArray.count
    }
    

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        NSLog("didSelect----\(categoryListArray [row])")
        categorySelected = categoryListArray [row]
    }
    
    func locationManager(manager : CLLocationManager,didChangeAuthorizationStatus status:CLAuthorizationStatus){
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        /*let location = locations.last
        
        latitude = "\(location!.coordinate.latitude)"
        print (latitude)
        
        longitude = "\(location!.coordinate.longitude)"
        print (longitude)
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        
        self.mapView.setRegion(region, animated: true)
        
        self.locationManager.stopUpdatingLocation()*/
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Errors: " + error.localizedDescription)
    }
    
    func receiveValueFromUserMapVC(givenLocation : MKPlacemark){
        print("givenLocation \(givenLocation )")
        selectedPin = givenLocation
        if let nonOptionalselectedPin : MKPlacemark = selectedPin {
            latitude = "\(nonOptionalselectedPin.coordinate.latitude)"
            longitude = "\(nonOptionalselectedPin.coordinate.longitude)"
             /*let retreivelocation = CLLocationCoordinate2D(latitude: nonOptionalselectedPin.coordinate.latitude,longitude: nonOptionalselectedPin.coordinate.longitude)
           // self.mapView.region = MKCoordinateRegionMakeWithDistance(retreivelocation, 1000, 1000)
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: retreivelocation, span: span)
            mapView.setRegion(region, animated: true)*/
        }
       
    }
    
    func receiveLocationValueFromUserMapVC(location : CLLocation){
        
        print("location -> \(location.coordinate.latitude)" )
        latitude = "\(location.coordinate.latitude)"
        longitude = "\(location.coordinate.longitude)"
       /* let retreivelocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude,longitude: location.coordinate.longitude)
        print(retreivelocation)
        //self.mapView.region = MKCoordinateRegionMakeWithDistance(retreivelocation, 1000, 1000)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: retreivelocation, span: span)
        mapView.setRegion(region, animated: true)*/
    }
    
  
    
    @IBAction func showUsersLocation(sender: AnyObject) {
        if let userMapView = self.storyboard?.instantiateViewControllerWithIdentifier("UserMapInputViewController") as? UserMapInputViewController{
            let navController = UINavigationController(rootViewController: userMapView)
            navController.setViewControllers([userMapView], animated: true)
            self.revealViewController().setFrontViewController(navController, animated: true)
        }
    }
    
    
    @IBAction func storeValueToDB(sender: AnyObject) {
        NSLog("inside of storeValueToDb")
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        if(categorySelected == ""){
            categorySelected = "Study"
        }
        NSLog("\(productName!.text)")
        NSLog("\(categorySelected)")
        NSLog("\(latitude)")
        NSLog("\(longitude)")
        //NSUserDefaults.standardUserDefaults().stringForKey("userEmail")
        //let userEntity = NSEntityDescription.entityForName("MCPLabUser", inManagedObjectContext: managedContext)
        // let user =  NSManagedObject(entity: userEntity!, insertIntoManagedObjectContext: managedContext)
        
        //user.setValue(NSUserDefaults.standardUserDefaults().stringForKey("userEmail"), forKey:"name")
        
        let entity = NSEntityDescription.entityForName("ProductInventory", inManagedObjectContext: managedContext)
        let product = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        
        
        product.setValue(productName!.text!, forKey: "name")
        product.setValue("request", forKey: "productType")
        product.setValue(categorySelected, forKey: "category")
        product.setValue(amountNumber!.text!, forKey: "amount")
        product.setValue(otherInformation!.text!, forKey: "other")
        product.setValue(latitude, forKey: "userLocLatitude")
        product.setValue(longitude, forKey: "userLocLongitude")
        product.setValue(NSDate(), forKey: "posted")
        product.setValue(NSUserDefaults.standardUserDefaults().stringForKey("userEmail"), forKey: "requestedUser")
        
        product.setValue(otherInformation!.text!, forKey: "other")
        
        //user.setValue(NSSet(object: product), forKey: "products")
        do{
            try product.managedObjectContext?.save()
            let myAlert = UIAlertController(title:"Alert", message:"product Added!!!",preferredStyle: UIAlertControllerStyle.Alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default){
                action in self.dismissViewControllerAnimated(true, completion: nil)
            }
            
            myAlert.addAction(okAction)
            self.presentViewController(myAlert, animated: true, completion: nil)
        }
            
        catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
        

    }

    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.productName.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        
        
        self.amountNumber.addTarget(self, action: "amountNumberTextFieldChange:", forControlEvents: UIControlEvents.EditingChanged)
        
        self.otherInformation.addTarget(self, action: "otherInfoTextFieldChange:", forControlEvents: UIControlEvents.EditingChanged)
    }
    
 
 

    
    @IBAction func goToMapView(sender: AnyObject) {
        if let userMapView = self.storyboard?.instantiateViewControllerWithIdentifier("UserMapInputViewController") as? UserMapInputViewController{
            let navController = UINavigationController(rootViewController: userMapView)
            navController.setViewControllers([userMapView], animated: true)
            self.revealViewController().setFrontViewController(navController, animated: true)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
