//
//  showProductDonationListViewController.swift
//  MCPLabLogin
//
//  Created by Khan hafizur rahman on 7/10/16.
//  Copyright © 2016 Khan hafizur rahman. All rights reserved.
//

import UIKit
import CoreData

class showProductDonationListViewController: UIViewController {
    


    
    @IBOutlet weak var productDonationTableView: UITableView!
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var choosenProductName = ""
    
    var choosenProductGivenByUser = ""

    var donationProducts = [NSManagedObject] ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "\"The List\""
        productDonationTableView.registerClass(UITableViewCell.self,forCellReuseIdentifier: "Cell")
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            //self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.revealViewController().panGestureRecognizer()
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        
        let fetchRequest = NSFetchRequest(entityName: "ProductInventory")
        
        let loginUserName = NSUserDefaults.standardUserDefaults().stringForKey("userEmail")!
        
        print(loginUserName)
        fetchRequest.predicate = NSPredicate(format: "requestedUser = %@ AND productType =%@", loginUserName,"donations")
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            donationProducts = results as! [NSManagedObject]
            for managedObject in results {
                print(managedObject.valueForKey("productType"))
            }
        } catch let error as NSError {
            print("could not fetch\(error),\(error.userInfo)")
        }
    }
    
    @IBAction func goToItemView(sender: UIButton) {
        NSLog("detailsClicked!!!")
        if let showDetailsView = self.storyboard?.instantiateViewControllerWithIdentifier("ShowDetailsItemVIewControllerID") as? ShowDetailsItemViewController {
            showDetailsView.productName = choosenProductName
            showDetailsView.productGivenByUser = choosenProductGivenByUser
            let navController = UINavigationController(rootViewController: showDetailsView)
            navController.setViewControllers([showDetailsView], animated: true)
            self.revealViewController().setFrontViewController(navController, animated: true)
        }
    }
    
}

extension showProductDonationListViewController : UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        NSLog("\(donationProducts.count)")
        return donationProducts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! TableViewCell
        let product = donationProducts[indexPath.row]
        choosenProductName = (product.valueForKey("name") as? String)!
        print(choosenProductName)
        choosenProductGivenByUser = (product.valueForKey("requestedUser") as? String)!
        cell.titleLabel.text = choosenProductName + "  " + choosenProductGivenByUser
        cell.sharedButton.tag = indexPath.row
        cell.sharedButton.addTarget(self, action: "goToItemView:", forControlEvents: .TouchUpInside)
        return cell
    }
    
}
