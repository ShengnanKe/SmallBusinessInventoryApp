//
//  Item+CoreDataProperties.swift
//  SmallBusinessInventoryApp
//
//  Created by KKNANXX on 5/12/24.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var itemdescription: String?
    @NSManaged public var name: String?
    @NSManaged public var ownershipstatus: Bool
    @NSManaged public var photo: String?
    @NSManaged public var hasTag: Tag?
    @NSManaged public var toContainer: Container?

}

extension Item : Identifiable {

}
