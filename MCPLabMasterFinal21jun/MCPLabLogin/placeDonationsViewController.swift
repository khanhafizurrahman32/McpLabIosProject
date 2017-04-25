//
//  placeDonationsViewController.swift
//  MCPLabLogin
//
//  Created by Khan hafizur rahman on 7/10/16.
//  Copyright © 2016 Khan hafizur rahman. All rights reserved.
//

import UIKit
import MapKit
import CoreData
import PhotosUI
import MobileCoreServices

class placeDonationsViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
 
    @IBOutlet weak var productName: UITextField!
    
    @IBOutlet weak var amountNumber: UITextField!
  
    @IBOutlet weak var otherInformation: UITextField!
    
    @IBOutlet weak var categories: UIPickerView!
    
    var categoryListArray = ["Study","cloth","food"]
    
    var categorySelected = ""
    
    var latitude = ""
    
    var longitude = ""
    
    var selectedPin:MKPlacemark? = nil
    
    var storeImageValue:NSData? = nil
    
    var imageChoosen = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // textField Delegate
        productName.delegate = self
        amountNumber.delegate = self
        otherInformation.delegate = self
        
        categories.delegate = self
        categories.dataSource = self
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.revealViewController().panGestureRecognizer()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        /*let viewControllers = self.navigationController?.viewControllers
         for viewController in viewControllers! {
         print(viewController)
         
         }
         //let viewController = viewControllers! [(viewControllers?.count)!]
         print("viewController \(viewControllers?.count)")*/
        
        productName.text = NSUserDefaults.standardUserDefaults().stringForKey("submitDonationProductNameValue")
        amountNumber.text = NSUserDefaults.standardUserDefaults().stringForKey("submitDonationAmountNumberValue")
        otherInformation.text = NSUserDefaults.standardUserDefaults().stringForKey("submitDonationOtherInfoValue")
        //self.imageView.image =
        
        
    }
    @IBAction func attachPhoto(sender: AnyObject) {
        showImagePicker(.PhotoLibrary)
    }
    
    @IBAction func storeDonationsToDB(sender: AnyObject) {
        NSLog("storeDonations!!!!")
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let entity = NSEntityDescription.entityForName("ProductInventory", inManagedObjectContext: managedContext)
        let product = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        product.setValue(productName!.text!, forKey: "name")
        if(categorySelected == ""){
            categorySelected = "Study"
        }
        product.setValue(categorySelected, forKey: "category")
        product.setValue("donations", forKey: "productType")
        product.setValue(amountNumber!.text!, forKey: "amount")
        product.setValue(latitude, forKey: "userLocLatitude")
        product.setValue(longitude, forKey: "userLocLongitude")
        product.setValue(NSDate(), forKey: "posted")
        product.setValue(NSUserDefaults.standardUserDefaults().stringForKey("userEmail"), forKey: "requestedUser")
        if(imageView.image == nil){
            displayMyAlertMessage("please choose a picture!")
            return
        }
        let picture = UIImageJPEGRepresentation(imageView.image!, 1)
        product.setValue(picture, forKey: "itemPicture")
        
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
    
    func displayMyAlertMessage(userMessage : String){
        let myAlert = UIAlertController(title: "ALERT!", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title:"OK",style: UIAlertActionStyle.Default, handler: nil)
        
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated: true, completion:nil)
    }
    
    @IBAction func showUserLocation(sender: AnyObject) {
        if let userMapView = self.storyboard?.instantiateViewControllerWithIdentifier("UserMapInputViewController") as? UserMapInputViewController{
            userMapView.setFromWhereItInvoked("donation")
            let navController = UINavigationController(rootViewController: userMapView)
            navController.setViewControllers([userMapView], animated: true)
            self.revealViewController().setFrontViewController(navController, animated: true)
        }
    }
    
    func receiveValueFromUserMapVC(givenLocation : MKPlacemark){
        print("givenLocation \(givenLocation )")
        selectedPin = givenLocation
        if let nonOptionalselectedPin : MKPlacemark = selectedPin {
            latitude = "\(nonOptionalselectedPin.coordinate.latitude)"
            longitude = "\(nonOptionalselectedPin.coordinate.longitude)"
        }
        
    }
    
    func receiveLocationValueFromUserMapVC(location : CLLocation){
        print("location -> \(location.coordinate.latitude)" )
        latitude = "\(location.coordinate.latitude)"
        longitude = "\(location.coordinate.longitude)"
    }
    
    private func showImagePicker(sourceType: UIImagePickerControllerSourceType){
        let imagePickerController = UIImagePickerController()
        imagePickerController.modalPresentationStyle = .CurrentContext
        imagePickerController.sourceType = sourceType
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.mediaTypes = [kUTTypeImage as String]
        
        self.presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    func textFieldDidChange(productName:UITextField){
        NSUserDefaults.standardUserDefaults().setObject(productName.text!,forKey: "submitDonationProductNameValue")
    }
    
    func amountNumberTextFieldChange(amountNumber:UITextField){
        print("insideamountNumberTextFieldChange")
        NSUserDefaults.standardUserDefaults().setObject(amountNumber.text!,forKey: "submitDonationAmountNumberValue")
    }
    
    func otherInfoTextFieldChange(otherInformation:UITextField){
        print("insideOtherInfoTextFieldChange")
        NSUserDefaults.standardUserDefaults().setObject(otherInformation.text!, forKey: "submitDonationOtherInfoValue")
    }

    
}

extension placeDonationsViewController : UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.productName.addTarget(self, action: #selector(placeDonationsViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        
        
        self.amountNumber.addTarget(self, action: #selector(placeDonationsViewController.amountNumberTextFieldChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        
        self.otherInformation.addTarget(self, action: #selector(placeDonationsViewController.otherInfoTextFieldChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
    }
    
}

extension placeDonationsViewController : UIImagePickerControllerDelegate{
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            NSUserDefaults.standardUserDefaults().setObject(UIImageJPEGRepresentation(image, 0.8), forKey: "submitDonationimageValue")
            print(NSUserDefaults.standardUserDefaults().stringForKey("submitDonationimageValue"))
            self.imageView.image = image
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension placeDonationsViewController : UINavigationControllerDelegate {
    
}

extension placeDonationsViewController : UIPickerViewDelegate {
    
}
extension placeDonationsViewController : UIPickerViewDataSource {
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
}





