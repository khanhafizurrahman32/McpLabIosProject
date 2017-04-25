//
//  selectionMessageController.swift
//  MCPLabLogin
//
//  Created by Khan hafizur rahman on 7/15/16.
//  Copyright © 2016 Khan hafizur rahman. All rights reserved.
//

import UIKit

class selectionMessageController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var passingString: String = ""
    
    var objects: NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.objects.addObject("iPhone")
        self.objects.addObject("apple watch")
        self.objects.addObject("MAC")
        
        
        self.tableView.reloadData()
    }
    
    
}



extension selectionMessageController : UITableViewDelegate {
    
}

extension selectionMessageController : UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell",forIndexPath: indexPath) as! SelectTableViewCell
        
        cell.titleLabel.text = self.objects.objectAtIndex(indexPath.row) as! String
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.objects.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let titleString = self.objects.objectAtIndex(indexPath.row) as? String
        if let nonOptionalTitle : String = titleString {
            passingString = nonOptionalTitle
            print(nonOptionalTitle)
             if let selectMessageView = self.storyboard?.instantiateViewControllerWithIdentifier("chatViewControllerStoryId") as? chatViewController {
                selectMessageView.selectedMessage = passingString
                self.presentViewController(selectMessageView, animated: true, completion: nil)
                
            }
        }
        
    }
}

