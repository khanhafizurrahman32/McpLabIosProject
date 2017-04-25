//
//  othersProfileViewController.swift
//  MCPLabLogin
//
//  Created by Khan hafizur rahman on 7/10/16.
//  Copyright © 2016 Khan hafizur rahman. All rights reserved.
//

import UIKit
import CoreData

class othersProfileViewController: UIViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var otherUserProfileName: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var likeNoLabel: UILabel!
    @IBOutlet weak var dislikeNoLabel: UILabel!
    var likeCount = " "
    var disLikeCount = " "
    
    var userName = ""
    var image = UIImage()
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.revealViewController().panGestureRecognizer()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear (animated)
        if(userName == NSUserDefaults.standardUserDefaults().stringForKey("userEmail")){
            print("equlas")
       // checkButton.hidden = true
        }
        otherUserProfileName.text = userName
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "UserRegistration")
        
        let predicate = NSPredicate(format: "%K == %@", "email",userName)
        fetchRequest.predicate = predicate
        
        do{
            let results = try managedContext.executeFetchRequest(fetchRequest)
            for managedObject in results {
                let imageFromDB = managedObject.valueForKey("picture") as? NSData
                let imageRetreived = UIImage (data: imageFromDB!)
                userImageView.image = imageRetreived
                likeCount = (managedObject.valueForKey("likeNo") as? String)!
                likeNoLabel.text = likeCount
                disLikeCount = (managedObject.valueForKey("dislikeNo") as? String)!
                
                dislikeNoLabel.text = disLikeCount
                
            }
        }catch {
            let fetchError = error as NSError
            print(fetchError)
        }
    }
    

    @IBAction func goToChatViewController(sender: AnyObject) {
       
        if let chatView = self.storyboard?.instantiateViewControllerWithIdentifier("chatViewControllerStoryId") as? chatViewController {
            chatView.sendToUser = userName
            let navController = UINavigationController(rootViewController: chatView)
            navController.setViewControllers([chatView], animated: true)
            self.revealViewController().setFrontViewController(navController, animated: true)
            //self.presentViewController(chatView, animated: true, completion: nil)
        }
    }
    

    @IBAction func increaseLikeValue(sender: AnyObject) {
        NSLog("increaseLikeValue")
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "UserRegistration")
        let predicate = NSPredicate(format: "%K == %@", "email",userName)
        fetchRequest.predicate = predicate
       
        do{
            let results = try managedContext.executeFetchRequest(fetchRequest)
            for managedObject in results {
                
                if(managedObject.valueForKey("likedBy") as? String == NSUserDefaults.standardUserDefaults().stringForKey("userEmail")){
                    displayMyAlertMessage("you liked once")
                }
                let likeIntValue = (likeCount as NSString).intValue + 1
                let c = String(likeIntValue)
                managedObject.setValue(c, forKey: "likeNo")
                managedObject.setValue(NSUserDefaults.standardUserDefaults().stringForKey("userEmail"), forKey: "likedBy")
                do {
                    try managedObject.managedObjectContext?.save()
                    likeNoLabel.text = c
                } catch {
                    let saveError = error as NSError
                    print(saveError)
                }
            }
        }catch{
            let fetchError = error as NSError
            print(fetchError)
        }
    }
    
    
    @IBAction func increaseDislikeValue(sender: AnyObject) {
        NSLog("decreaseDislikeValue")
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "UserRegistration")
        let predicate = NSPredicate(format: "%K == %@", "email",userName)
        fetchRequest.predicate = predicate
        do{
            let results = try managedContext.executeFetchRequest(fetchRequest)
            for managedObject in results {
                
                if(managedObject.valueForKey("dislikedBy") as? String == NSUserDefaults.standardUserDefaults().stringForKey("userEmail")){
                    displayMyAlertMessage("you disliked once")
                }
                let dislikeIntValue = (disLikeCount as NSString).intValue + 1
                let c = String(dislikeIntValue)
                managedObject.setValue(c, forKey: "dislikeNo")
                managedObject.setValue(NSUserDefaults.standardUserDefaults().stringForKey("userEmail"), forKey: "dislikedBy")
                do {
                    try managedObject.managedObjectContext?.save()
                    dislikeNoLabel.text = c
                } catch {
                    let saveError = error as NSError
                    print(saveError)
                }
            }
        }catch{
            let fetchError = error as NSError
            print(fetchError)
        }
    }
    
   
    
    func displayMyAlertMessage(userMessage : String){
        let myAlert = UIAlertController(title: "ALERT!", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title:"OK",style: UIAlertActionStyle.Default, handler: nil)
        
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated: true, completion:nil)
    }
}
