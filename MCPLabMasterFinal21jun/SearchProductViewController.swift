//
//  SearchProductViewController.swift
//  MCPLabLogin
//
//  Created by Khan hafizur rahman on 6/21/16.
//  Copyright © 2016 Khan hafizur rahman. All rights reserved.
//

import UIKit
import CoreData
import MapKit
import CoreLocation
class SearchProductViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,CLLocationManagerDelegate,MKMapViewDelegate,UITextFieldDelegate{

    @IBOutlet weak var productName: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var surroundingDistance: UIPickerView!
    var surroundingDistancesArray = ["50","100","200"]
    var distanceChoosen = ""
    let locationManager = CLLocationManager()
    var selectedPin:MKPlacemark? = nil
    var address = ""
    var requestedUser = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //map view Delegate Code
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            self.locationManager.requestWhenInUseAuthorization()
        } else if CLLocationManager.authorizationStatus() != .AuthorizedWhenInUse {
            UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
        }
        
        /*if CLLocationManager.locationServicesEnabled() {
            print("enabled")
            self.locationManager.startUpdatingLocation()
        }*/
        //locationManager.requestWhenInUseAuthorization()
        self.mapView.delegate = self
        locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
        self.productName.delegate = self
       
        
       
        // menu item Code
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            //self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
             self.revealViewController().panGestureRecognizer()
        }
        
        // pickerViewCode
        surroundingDistance.delegate = self
        surroundingDistance.dataSource = self
        

        // Do any additional setup after loading the view.
    }
    

    
    func getDirections(){
        if let selectedPin = selectedPin {
            let mapItem = MKMapItem(placemark: selectedPin)
            let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
            mapItem.openInMapsWithLaunchOptions(launchOptions)
        }
    }
    
    // othersProfileViewControllerStoryBoardId
    
    func getUserInfo(){
        NSLog("inside into getUserInfo")
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "UserRegistration")
        let predicate = NSPredicate(format: "%K == %@", "email", requestedUser)
        fetchRequest.predicate = predicate
        
        do {
          let results = try managedContext.executeFetchRequest(fetchRequest)
            print(results.count)
            for managedObject in results {
                if let otherView = self.storyboard?.instantiateViewControllerWithIdentifier("othersProfileViewControllerStoryBoardId") as? othersProfileViewController {
                   // otherView.setUserNameAfterSearch(requestedUser)
                    let imageFromDB = managedObject.valueForKey("picture") as? NSData
                    let image = UIImage (data: imageFromDB!)
                   // otherView.setUserNameAfterSearchPress(image!)
                    self.presentViewController(otherView, animated: true, completion: nil)
                }
            }
        }catch let error as NSError{
            print(" \(error.description)")
        }
    }
    
    func getProductDetails(){
        if let showDetailsView = self.storyboard?.instantiateViewControllerWithIdentifier("ShowDetailsItemVIewControllerID") as? ShowDetailsItemViewController {
            showDetailsView.productName = productName.text!
            showDetailsView.productGivenByUser = requestedUser
            let navController = UINavigationController(rootViewController: showDetailsView)
            navController.setViewControllers([showDetailsView], animated: true)
            self.revealViewController().setFrontViewController(navController, animated: true)
            //self.presentViewController(showDetailsView, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
        // Dispose of any resources that can be recreated.
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return surroundingDistancesArray[row]
    }
   
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return surroundingDistancesArray.count
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       distanceChoosen = surroundingDistancesArray [row]
        print("distanceChoosen \(distanceChoosen)")
    }
    
    @IBAction func SearchItem(sender: UIButton) {
        NSLog("search button pressed")
      
        
        let productForSearch = productName.text!
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "ProductInventory")
        
        let predicate = NSPredicate(format: "%K == %@", "name",productForSearch)
        fetchRequest.predicate = predicate
        
        do{
            let result = try managedContext.executeFetchRequest(fetchRequest)
            
            for managedObject in result {
                requestedUser = ((managedObject.valueForKey("requestedUser") as? NSString))! as String
                print("requestedUser-> \(requestedUser)")
                print("result ->\(managedObject.valueForKey("name"))")
                print("location ->\(managedObject.valueForKey("userLocLatitude"))")
                print("date -> \(managedObject.valueForKey("posted"))")
                let latitude = ((managedObject.valueForKey("userLocLatitude") as? NSString)?.doubleValue)!
                print("latitude ->\(latitude)")
                let longitude = ((managedObject.valueForKey("userLocLongitude") as? NSString)?.doubleValue)!
                let interestingPosition = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                let pointAnnotation = MKPointAnnotation ()
                let productType = managedObject.valueForKey("productType") as? String
                pointAnnotation.coordinate = interestingPosition
                let coords = CLLocationCoordinate2DMake(latitude, longitude)
                selectedPin = MKPlacemark(coordinate: coords, addressDictionary: nil)
                pointAnnotation.title = productType! + " Item found!!!"
                self.mapView.addAnnotation(pointAnnotation)
                self.mapView.setCenterCoordinate(interestingPosition, animated: true)
            }
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
    }
    
  
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if (annotation.title! == "donations Item found!!!") || (annotation.title! == "request Item found!!!") {
            NSLog("interesting!!!!!!!!!!")
            let aView = MKPinAnnotationView.init(annotation: annotation, reuseIdentifier: nil)
            aView.pinTintColor = UIColor.blueColor()
            aView.animatesDrop = true
            aView.canShowCallout = true
            let smallSquare = CGSize(width: 30, height: 30)
            let button = UIButton(frame: CGRect(origin: CGPointZero, size: smallSquare))
            button.setBackgroundImage(UIImage(named: "car"), forState: .Normal)
            button.addTarget(self, action: #selector(SearchProductViewController.getProductDetails), forControlEvents: .TouchUpInside)
            aView.leftCalloutAccessoryView = button
            return aView
        }
       return nil
    }
    // Mark : Location Delegate Method
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        print(location)
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude,longitude: location!.coordinate.longitude)
        
        // based on selection of distance picker view
        /*if(distanceChoosen == ""){
           self.mapView.region = MKCoordinateRegionMakeWithDistance(center, 100, 100)
        }
        else {
            let choosenCoordinate = Double(distanceChoosen)
           self.mapView.region = MKCoordinateRegionMakeWithDistance(center,choosenCoordinate!,choosenCoordinate!)
        }*/
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        self.mapView.setRegion(region, animated: true)
        //self.locationManager.stopUpdatingLocation()
        
    }

    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("mapError\(error.localizedDescription)")
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func viewDidAppear(animated: Bool) {
        
        NSLog("inside viewDidAppear method!!!!")
        let isUserLoggedIn = NSUserDefaults.standardUserDefaults().boolForKey("isUserLoggedIn")
        if(!isUserLoggedIn){
            self.performSegueWithIdentifier("loginView2", sender: self)
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
