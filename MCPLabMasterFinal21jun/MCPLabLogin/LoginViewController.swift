//
//  LoginViewController.swift
//  MCPLabLogin
//
//  Created by Khan hafizur rahman on 6/5/16.
//  Copyright © 2016 Khan hafizur rahman. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class LoginViewController: UIViewController {
    //MaRK properties
    
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    var loginUsers = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userEmailTextField.delegate = self
        self.userPasswordTextField.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func loginButtonTapped(sender: AnyObject) {
        
        let userEmail = userEmailTextField.text
        let userPassword = userPasswordTextField.text
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "UserRegistration")
        fetchRequest.predicate = NSPredicate(format: "email = %@ AND password =%@", userEmail!,userPassword!)
        
        do{
            let results = try managedContext.executeFetchRequest(fetchRequest)
            for managedObject in results{
                let userEmailStored = managedObject.valueForKey("email") as! String
                let userPasswordStored = managedObject.valueForKey("password") as! String
                print("userEmailStored->\(userEmailStored) userEmail->\(userEmail!)")
                print("userPassStored->\(userPasswordStored) userpass->\(userPassword!)")
                if(userEmailStored == userEmail){
                    if(userPasswordStored == userPassword){
                        NSLog("loginSuccessful")
                        NSUserDefaults.standardUserDefaults().setObject(userEmail,forKey: "userEmail")
                        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isUserLoggedIn")
                        NSUserDefaults.standardUserDefaults().synchronize()
                        FIRAuth.auth()?.createUserWithEmail(userEmail!, password: userPasswordStored) { (user, error) in
                            if let error = error {
                                print(error.localizedDescription)
                                return
                            }
                            self.signedIn(user!)
                        }
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                }
            }
        }catch let error as NSError{
            print("Could not fetch \(error),\(error.userInfo)")
        }
        
        /*121234let userEmailStored = NSUserDefaults.standardUserDefaults().stringForKey("userEmail")
        let userPasswordStored = NSUserDefaults.standardUserDefaults().stringForKey("userPassword")
        
        if(userEmailStored == userEmail){
            if(userPasswordStored == userPassword){
                //login is successful
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isUserLoggedIn")
                NSUserDefaults.standardUserDefaults().synchronize()
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }*/
    }
    
    func signedIn(user: FIRUser?) {
        MeasurementHelper.sendLoginEvent()
        
        AppState.sharedInstance.displayName = user?.displayName ?? user?.email
        AppState.sharedInstance.photoUrl = user?.photoURL
        AppState.sharedInstance.signedIn = true
        NSNotificationCenter.defaultCenter().postNotificationName(Constants.NotificationKeys.SignedIn, object: nil, userInfo: nil)
        //performSegueWithIdentifier(Constants.Segues.SignInToFp, sender: nil)
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

extension LoginViewController : UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
