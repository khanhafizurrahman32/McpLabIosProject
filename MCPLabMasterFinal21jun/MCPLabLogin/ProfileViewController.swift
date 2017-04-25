//
//  ProfileViewController.swift
//  MCPLabLogin
//
//  Created by Khan hafizur rahman on 6/30/16.
//  Copyright © 2016 Khan hafizur rahman. All rights reserved.
//

import UIKit
import CoreData

class ProfileViewController: UIViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var loginUserName: UILabel!
    @IBOutlet weak var loginUserImageView: UIImageView!
    @IBOutlet weak var likeNumberShow: UILabel!
    @IBOutlet weak var dislikeNumberShow: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
           menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let loginUser = NSUserDefaults.standardUserDefaults().stringForKey("userEmail")
        loginUserName.text = loginUser
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "UserRegistration")
        
        let predicate = NSPredicate(format: "%K == %@", "email",loginUser!)
        fetchRequest.predicate = predicate
        
        
        
        do{
            let results = try managedContext.executeFetchRequest(fetchRequest)
            for managedObject in results {
                let imageFromDB = managedObject.valueForKey("picture") as? NSData
                let imageRetreived = UIImage (data: imageFromDB!)
               loginUserImageView.image = imageRetreived
                let likeNumber = managedObject.valueForKey("likeNo") as? String
                likeNumberShow.text = likeNumber
                let dislikeNumber = managedObject.valueForKey("dislikeNo") as? String
                dislikeNumberShow.text = dislikeNumber
            }
        }catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func logoutButtontapped(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isUserLoggedIn")
        NSUserDefaults.standardUserDefaults().synchronize()
        self.performSegueWithIdentifier("loginView", sender: self)
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
