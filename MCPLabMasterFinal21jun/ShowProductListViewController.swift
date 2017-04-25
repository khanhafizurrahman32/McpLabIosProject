//
//  ShowProductListViewController.swift
//  MCPLabLogin
//
//  Created by Khan hafizur rahman on 6/21/16.
//  Copyright © 2016 Khan hafizur rahman. All rights reserved.
//

import UIKit
import CoreData

class ShowProductListViewController: UIViewController,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    var products = [NSManagedObject] ()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "\"The List\""
        tableView.registerClass(UITableViewCell.self,forCellReuseIdentifier: "Cell")
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        NSLog("\(products.count)")
        return products.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        let product = products[indexPath.row]
        
        
        cell!.textLabel!.text = (product.valueForKey("name") as? String)! + " " + (product.valueForKey("amount") as? String)!
        return cell!
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        
        let fetchRequest = NSFetchRequest(entityName: "ProductInventory")
        
        let loginUserName = NSUserDefaults.standardUserDefaults().stringForKey("userEmail")!
        print("loginUserName --> \(loginUserName)")
        
        /*let predicate = NSPredicate(format: "%K == %@", "requestedUser",loginUserName)
        fetchRequest.predicate = predicate*/
        fetchRequest.predicate = NSPredicate(format: "requestedUser = %@ AND productType =%@", loginUserName,"request")
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            products = results as! [NSManagedObject]
        } catch let error as NSError{
            print("Could not fetch \(error),\(error.userInfo)")
        }
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
