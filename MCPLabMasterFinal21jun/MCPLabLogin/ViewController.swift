//
//  ViewController.swift
//  MCPLabLogin
//
//  Created by Khan hafizur rahman on 6/3/16.
//  Copyright © 2016 Khan hafizur rahman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var menuButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
        let isUserLoggedIn = NSUserDefaults.standardUserDefaults().boolForKey("isUserLoggedIn")
        if(!isUserLoggedIn){
             self.performSegueWithIdentifier("loginView", sender: self)
        }
       
    }
    
    
    @IBAction func logoutButtonTapped(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isUserLoggedIn")
        NSUserDefaults.standardUserDefaults().synchronize()
        self.performSegueWithIdentifier("loginView", sender: self)
        
    }

}

