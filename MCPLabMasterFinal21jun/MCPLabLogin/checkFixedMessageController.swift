//
//  checkFixedMessageController.swift
//  MCPLabLogin
//
//  Created by Khan hafizur rahman on 7/20/16.
//  Copyright © 2016 Khan hafizur rahman. All rights reserved.
//

import UIKit

class checkFixedMessageController: UITableViewController {
    
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.revealViewController().panGestureRecognizer()
        }
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        NSLog("You selected cell number: \(indexPath.row)!")
        let currentCell = self.tableView.cellForRowAtIndexPath(indexPath) as UITableViewCell!;
        print(currentCell.textLabel?.text)
        /*if let selectMessageView = self.storyboard?.instantiateViewControllerWithIdentifier("chatViewControllerStoryId") as? chatViewController {
            selectMessageView.selectedRowNumber = indexPath.row
            /*let navController = UINavigationController(rootViewController: selectMessageView)
            navController.setViewControllers([selectMessageView], animated: true)
            self.revealViewController().setFrontViewController(navController, animated: true)*/
            self.presentViewController(selectMessageView, animated: true, completion: nil)
            
        }*/

        /*let titleString = self.objects.objectAtIndex(indexPath.row) as? String
        if let nonOptionalTitle : String = titleString {
            passingString = nonOptionalTitle
            print(nonOptionalTitle)
            if let selectMessageView = self.storyboard?.instantiateViewControllerWithIdentifier("chatViewControllerStoryId") as? chatViewController {
                selectMessageView.selectedMessage = passingString
                self.presentViewController(selectMessageView, animated: true, completion: nil)
                
            }
        }*/
        
        
    }
}


