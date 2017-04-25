//
//  MCPLabUser+CoreDataProperties.swift
//  MCPLabLogin
//
//  Created by Khan hafizur rahman on 6/20/16.
//  Copyright © 2016 Khan hafizur rahman. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension MCPLabUser {

    @NSManaged var name: String?
    @NSManaged var products: NSSet?

}
