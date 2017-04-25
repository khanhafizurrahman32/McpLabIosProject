//
//  RegisterPageViewControlerViewController.swift
//  MCPLabLogin
//
//  Created by Khan hafizur rahman on 6/4/16.
//  Copyright © 2016 Khan hafizur rahman. All rights reserved.
//

import UIKit
import CoreData
import PhotosUI
import MobileCoreServices
import Firebase

class RegisterPageViewControlerViewController: UIViewController {
    // MARK Properties
    
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userEmailTextField.delegate = self
        self.userPasswordTextField.delegate = self
        self.repeatPasswordTextField.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK Actions
    
    @IBAction func registerButtonTaped(sender: AnyObject) {
        let userEmail = userEmailTextField.text
        let userPassword = userPasswordTextField.text
        let userRepeatPassword = repeatPasswordTextField.text
        
        if(imageView.image == nil){
            displayMyAlertMessage("please choose a picture!")
            return
        }
        let picture = UIImageJPEGRepresentation(imageView.image!, 1)
        
        // check for empty fields
        if(userEmail!.isEmpty || userPassword!.isEmpty || userRepeatPassword!.isEmpty)
        {
            // Display alert Message
            displayMyAlertMessage("All fields are required")
            return
        }
        print(userEmail?.containsString("@"))
        // check if it has @
        if ((userEmail?.containsString("@")) == false){
            displayMyAlertMessage("wrong mail address")
        }
        // check password length
        if(userPassword?.characters.count < 6){
            displayMyAlertMessage("password should have atleast 6 characters")
        }
        
        if(userPassword != userRepeatPassword){
            
            //Display Alert message
            displayMyAlertMessage("password do not match")
            
        }
        
        
        // storeData
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "UserRegistration")
        fetchRequest.predicate = NSPredicate(format: "email = %@", userEmail!)
        do{
            let results = try managedContext.executeFetchRequest(fetchRequest)
            if(results.count != 0){
                displayMyAlertMessage("user already exists!!!")
                return
            }
        } catch let error as NSError {
            print("could not fetch\(error),\(error.userInfo)")
        }
        
        let userRegistrationEntity = NSEntityDescription.entityForName("UserRegistration",inManagedObjectContext: managedContext)
        
        
        let userRegistration = NSManagedObject(entity: userRegistrationEntity!, insertIntoManagedObjectContext: managedContext)
        
        
        userRegistration.setValue(userEmail, forKey: "email")
        userRegistration.setValue(userPassword, forKey: "password")
        userRegistration.setValue(userRepeatPassword, forKey: "repeatPassword")
        userRegistration.setValue(picture, forKey: "picture")
        userRegistration.setValue("0", forKey: "likeNo")
        userRegistration.setValue("0", forKey: "dislikeNo")
        
        do{
            try userRegistration.managedObjectContext?.save()
        }
            
        catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        
        /*NSUserDefaults.standardUserDefaults().setObject(userEmail,forKey: "userEmail")
         NSUserDefaults.standardUserDefaults().setObject(userPassword, forKey: "userPassword")
         NSUserDefaults.standardUserDefaults().synchronize()*/
        
        //Display Alert MEssage with Confirmation
        var myAlert = UIAlertController(title:"Alert", message:"Registration is successful. Thank you",preferredStyle: UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default){
            action in self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated: true, completion: nil)
    }
    
    
    func displayMyAlertMessage(userMessage : String){
        let myAlert = UIAlertController(title: "ALERT!", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title:"OK",style: UIAlertActionStyle.Default, handler: nil)
        
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated: true, completion:nil)
    }
    
    
    @IBAction func selectPictureFromLibrary(sender: AnyObject) {
        showImagePicker(.PhotoLibrary)
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
}

extension RegisterPageViewControlerViewController : UIImagePickerControllerDelegate{
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imageView.image = image
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension RegisterPageViewControlerViewController : UINavigationControllerDelegate {
    
}

extension RegisterPageViewControlerViewController : UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

