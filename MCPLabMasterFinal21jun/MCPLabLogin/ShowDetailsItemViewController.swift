//
//  ShowDetailsItemViewController.swift
//  MCPLabLogin
//
//  Created by Khan hafizur rahman on 7/10/16.
//  Copyright © 2016 Khan hafizur rahman. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class ShowDetailsItemViewController: UIViewController {
    
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var otherInformation: UILabel!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var amountNumber: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    var requestedUser = ""
    
    var productName = ""
    var productGivenByUser = ""
    var donationProducts = [NSManagedObject] ()
    var longitude = 0.0
    var latitude = 0.0
    
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            //self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.revealViewController().panGestureRecognizer()
        }
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        //self.mapView.showsUserLocation = true
        mapView.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "ProductInventory")
        fetchRequest.predicate = NSPredicate(format: "requestedUser = %@ AND name =%@", productGivenByUser,productName)
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            donationProducts = results as! [NSManagedObject]
            for managedObject in results {
                requestedUser = (managedObject.valueForKey("requestedUser") as? String)!
                categoryName.text = managedObject.valueForKey("category") as? String
                amountNumber.text = managedObject.valueForKey("amount") as? String
                let imageFromDB = managedObject.valueForKey("itemPicture") as? NSData
                if let nonOptionalImageFromDB:NSData = imageFromDB {
                    let image = UIImage (data: nonOptionalImageFromDB)
                    if let nonOptionalimage : UIImage = image {
                        imageView.image = nonOptionalimage
                    }
                }
    

                let retreiveLatitude = (managedObject.valueForKey("userLocLatitude") as? NSString)
                if let nonretreiveLatitude:NSString = retreiveLatitude {
                    print(nonretreiveLatitude)
                    latitude = nonretreiveLatitude.doubleValue
                }
                let retreiveLongitude = (managedObject.valueForKey("userLocLongitude") as? NSString)
                if let nonretreiveLongitude:NSString = retreiveLongitude {
                    longitude = nonretreiveLongitude.doubleValue
                }
                print(latitude)
                let retreiveLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                self.mapView.region = MKCoordinateRegionMakeWithDistance(retreiveLocation, 1000, 1000)
                let pointAnnotation = MKPointAnnotation()
                pointAnnotation.coordinate = retreiveLocation
                pointAnnotation.title = "requiredLocation"
                self.mapView.addAnnotation(pointAnnotation)
                
            }
        }catch let error as NSError {
            print("could not fetch\(error),\(error.userInfo)")
        }
        print(productName)
    }
    
    @IBAction func gotoUserProfileView(sender: AnyObject) {
        if let otherUserProfileView = self.storyboard?.instantiateViewControllerWithIdentifier("othersProfileViewControllerStoryBoardId") as? othersProfileViewController {
            otherUserProfileView.userName = requestedUser
            let navController = UINavigationController(rootViewController: otherUserProfileView)
            navController.setViewControllers([otherUserProfileView], animated: true)
            self.revealViewController().setFrontViewController(navController, animated: true)
            //self.presentViewController(otherUserProfileView, animated: true, completion: nil)
        }
    }
    
}

extension ShowDetailsItemViewController : CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        /*if let location = locations.first {
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
            myLocation = location
        }*/
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print ("error:: \(error)")
    }
}

extension ShowDetailsItemViewController: MKMapViewDelegate {
    
}
