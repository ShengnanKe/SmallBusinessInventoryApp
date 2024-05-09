//
//  InventoryContainer+CoreDataProperties.swift
//  SmallBusinessInventoryApp
//
//  Created by KKNANXX on 5/9/24.
//
//

import Foundation
import CoreData


extension InventoryContainer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<InventoryContainer> {
        return NSFetchRequest<InventoryContainer>(entityName: "InventoryContainer")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var hasItems: NSSet?
    @NSManaged public var toSection: InventorySection?

}

// MARK: Generated accessors for hasItems
extension InventoryContainer {

    @objc(addHasItemsObject:)
    @NSManaged public func addToHasItems(_ value: InventoryItem)

    @objc(removeHasItemsObject:)
    @NSManaged public func removeFromHasItems(_ value: InventoryItem)

    @objc(addHasItems:)
    @NSManaged public func addToHasItems(_ values: NSSet)

    @objc(removeHasItems:)
    @NSManaged public func removeFromHasItems(_ values: NSSet)

}

extension InventoryContainer : Identifiable {

}
