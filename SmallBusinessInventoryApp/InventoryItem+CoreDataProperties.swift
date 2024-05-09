//
//  InventoryItem+CoreDataProperties.swift
//  SmallBusinessInventoryApp
//
//  Created by KKNANXX on 5/9/24.
//
//

import Foundation
import CoreData


extension InventoryItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<InventoryItem> {
        return NSFetchRequest<InventoryItem>(entityName: "InventoryItem")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var photo: Data?
    @NSManaged public var itemDescription: String?
    @NSManaged public var ownershipStatus: Bool
    @NSManaged public var tag: String?
    @NSManaged public var toContainer: InventoryContainer?

}

extension InventoryItem : Identifiable {

}
