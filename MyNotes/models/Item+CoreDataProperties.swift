//
//  Item+CoreDataProperties.swift
//  MyNotes
//
//  Created by jay on 2016-11-25.
//  Copyright © 2016 jay. All rights reserved.
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item");
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var done: Bool
    @NSManaged public var image: [Data]?
    @NSManaged public var name: String?

}
