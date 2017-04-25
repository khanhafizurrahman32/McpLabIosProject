//
//  chatViewController.swift
//  MCPLabLogin
//
//  Created by Khan hafizur rahman on 7/18/16.
//  Copyright © 2016 Khan hafizur rahman. All rights reserved.
//

import UIKit
import Photos
import Firebase
import GoogleMobileAds

class chatViewController: UIViewController {
    
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var clientTable: UITableView!
    
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var textField: UITextField!
    
    var ref: FIRDatabaseReference!
    
    var messages: [FIRDataSnapshot]! = []
    
    var msgLength: NSNumber = 10
    
    var selectedMessage = ""
    
    private var _refHandle: FIRDatabaseHandle!
    
    var storageRef: FIRStorageReference!
    
    var remoteConfig: FIRRemoteConfig!
    
    var sendToUser = ""
    
    var loginUserName = ""
    
    var selectedRowNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.revealViewController().panGestureRecognizer()
        }
        
        self.clientTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "tableViewCell")
        
        configureDatabase()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
        print("select :-> \(selectedMessage)")
        if (selectedMessage != " "){
            textField.text = selectedMessage
            
        }
        
        if(selectedRowNumber == 1){
            textField.text = "Hello"
        }
        
        if(selectedRowNumber == 2){
            textField.text = "Thank you very much"
        }
        
        if(selectedRowNumber == 3){
            textField.text = "Can you share your contacts please"
        }
        
        if(selectedRowNumber == 4){
            textField.text = "You can contact me at number:"
        }
        
        if(selectedRowNumber == 5){
            textField.text = "We can meet in... at..."
        }
        
        if(selectedRowNumber == 6){
            textField.text = "When and where can we meet?"
        }
        
        if(selectedRowNumber == 7){
            textField.text = "Is the item still available?"
        }
        
        if(selectedRowNumber == 8){
            textField.text = "Could you please reserve the item for me?"
        }
        
        if(selectedRowNumber == 9){
            textField.text = "Have a nice day"
        }
        
        if(selectedRowNumber == 10){
            textField.text = "Do you speak English?"
        }
    }
    
    
    deinit {
        self.ref.child("messages").removeObserverWithHandle(_refHandle)
    }
    
    func configureDatabase(){
        NSLog("configure Databases")
        loginUserName = NSUserDefaults.standardUserDefaults().stringForKey("userEmail")!
        var checkOtherUser = ""
        if let nonOptionalsendTouser :String = sendToUser {
            checkOtherUser = nonOptionalsendTouser
        }
        ref = FIRDatabase.database().reference()
        _refHandle = self.ref.child("messages").observeEventType(.ChildAdded, withBlock: { (snapshot) -> Void in
            print(self.loginUserName)
            print(checkOtherUser)
            print(" hi " + ((snapshot.value?.objectForKey("name"))! as! String))
            
            if((snapshot.value?.objectForKey("name") as! String) == self.loginUserName || (snapshot.value?.objectForKey("name") as! String) == checkOtherUser){
                self.messages.append(snapshot)
                self.clientTable.insertRowsAtIndexPaths([NSIndexPath(forRow: self.messages.count-1, inSection: 0)], withRowAnimation: .Automatic)
            }
        })
    }
    
    
    
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        
        let newLength = text.utf16.count + string.utf16.count - range.length
        return newLength <= self.msgLength.integerValue // Bool
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Dequeue cell
        let cell: UITableViewCell! = self.clientTable.dequeueReusableCellWithIdentifier("tableViewCell", forIndexPath: indexPath)
        let messageSnapshot: FIRDataSnapshot! = self.messages[indexPath.row]
        let message = messageSnapshot.value as! Dictionary<String, String>
        let name = message[Constants.MessageFields.name] as String!
        let text = message[Constants.MessageFields.text] as String!
        if let nonOptionalName :String = name {
            if let nonOptionalText : String = text {
                cell!.textLabel?.text = nonOptionalName + ": " + nonOptionalText
            }
        }
        
        cell!.imageView?.image = UIImage(named: "ic_account_circle")
        if let photoUrl = message[Constants.MessageFields.photoUrl], url = NSURL(string:photoUrl), data = NSData(contentsOfURL: url) {
            cell!.imageView?.image = UIImage(data: data)
        }
        return cell!
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let data = [Constants.MessageFields.text: textField.text! as String]
        sendMessage(data)
        return true
    }
    
    func sendMessage(data: [String: String]) {
        var mdata = data
        mdata[Constants.MessageFields.name] = NSUserDefaults.standardUserDefaults().stringForKey("userEmail")
        if let photoUrl = AppState.sharedInstance.photoUrl {
            mdata[Constants.MessageFields.photoUrl] = photoUrl.absoluteString
        }
        
        self.ref.child("messages").childByAutoId().setValue(mdata)
    }
    
    @IBAction func didSendMessage(sender: AnyObject) {
        textFieldShouldReturn(textField)
    }
    
    
    @IBAction func chooseSelectedMessage(sender: AnyObject) {
       /* NSLog("chooseSelectedMessage is 00000")
        if let selectMessageView = self.storyboard?.instantiateViewControllerWithIdentifier("selectionMessageControllerId") as? selectionMessageController {
            self.presentViewController(selectMessageView, animated: true, completion: nil)
            
        }*/
    }
    
}
