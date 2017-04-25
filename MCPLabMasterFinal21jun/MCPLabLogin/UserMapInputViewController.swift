//
//  UserMapInputViewController.swift
//  MCPLabLogin
//
//  Created by Khan hafizur rahman on 7/7/16.
//  Copyright © 2016 Khan hafizur rahman. All rights reserved.
//

import UIKit
import MapKit


protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}
class UserMapInputViewController: UIViewController {
    

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var mapView: MKMapView!

    
    let locationManager = CLLocationManager()
    var resultSearchController:UISearchController? = nil
    var selectedPin:MKPlacemark? = nil
    var myLocation = CLLocation(latitude: 0.0, longitude:  0.0)
    var fromWhereItComesFrom = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        self.mapView.showsUserLocation = true
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            //self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.revealViewController().panGestureRecognizer()
        }
        
        let locationSearchTable = storyboard!.instantiateViewControllerWithIdentifier("LocationSearchTable") as! LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController?.searchBar
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self // here locationSearchTable.handleMapSearchDelegate = nil
        mapView.delegate = self
    }
    
    func getDirections(){
        if let selectedPin = selectedPin {
            /*let mapItem = MKMapItem(placemark: selectedPin)
             let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
             mapItem.openInMapsWithLaunchOptions(launchOptions)*/
            
        }
        
        if (getFromWhereItInvoked() == "donation"){
            print("placeDonationsViewController")
            if let placeDonationsView = self.storyboard?.instantiateViewControllerWithIdentifier("placeDonationsViewControllerStoryBoardID") as? placeDonationsViewController {
                let navController = UINavigationController(rootViewController: placeDonationsView )
                navController.setViewControllers([placeDonationsView], animated: true)
                let productDetailsVC = navController.viewControllers.first as! placeDonationsViewController
                if(selectedPin != nil){
                    productDetailsVC.receiveValueFromUserMapVC(selectedPin!)
                } else {
                    productDetailsVC.receiveLocationValueFromUserMapVC(myLocation)
                }
                self.revealViewController().setFrontViewController(navController, animated: true)
            }
        }else {
            if let productDetailsView = self.storyboard?.instantiateViewControllerWithIdentifier("productDetailsViewStoryBoardID") as? ProductDetailsViewController {
                let navController = UINavigationController(rootViewController: productDetailsView)
                navController.setViewControllers([productDetailsView], animated: true)
                print("check \(navController.viewControllers.first as! ProductDetailsViewController)")
                let productDetailsVC = navController.viewControllers.first as! ProductDetailsViewController
                if(selectedPin != nil){
                    productDetailsVC.receiveValueFromUserMapVC(selectedPin!)
                } else {
                    productDetailsVC.receiveLocationValueFromUserMapVC(myLocation)
                }
                self.revealViewController().setFrontViewController(navController, animated: true)
            }
        }
        
        // self.performSegueWithIdentifier("userMapToProductSubmissionValue", sender: self)
        //self.navigationController?.popViewControllerAnimated(true)
        //dismissViewControllerAnimated(true, completion: nil)
    }
    
    func setFromWhereItInvoked(controllerName : String){
        fromWhereItComesFrom = controllerName
    }
    
    func getFromWhereItInvoked() -> String{
        return fromWhereItComesFrom
    }
    
    @IBAction func showCurrentUserLocation(sender: AnyObject) {
        getDirections()
    }

    
}

extension UserMapInputViewController : CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
            myLocation = location
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print ("error:: \(error)")
    }
}

extension UserMapInputViewController: HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark) {
        NSLog("dropPinZoomIn \(placemark) ")
        selectedPin = placemark
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        //model?.storeData = placemark.coordinate
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region,animated: true)
        
    }
}

extension UserMapInputViewController: MKMapViewDelegate {
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?{
        if annotation is MKUserLocation {
            return nil
        }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        pinView = MKPinAnnotationView(annotation:annotation, reuseIdentifier:reuseId)
        pinView?.pinTintColor = UIColor.orangeColor()
        pinView?.canShowCallout = true
        let smallSquare = CGSize(width: 30, height: 30)
        let button = UIButton(frame: CGRect(origin: CGPointZero,size:smallSquare))
        button.setBackgroundImage(UIImage(named: "OK"), forState: .Normal)
        button.addTarget(self, action: #selector(UserMapInputViewController.getDirections), forControlEvents: .TouchUpInside)
        pinView?.leftCalloutAccessoryView  = button
        return pinView
    }
}
