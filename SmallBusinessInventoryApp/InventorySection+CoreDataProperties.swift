//
//  InventorySection+CoreDataProperties.swift
//  SmallBusinessInventoryApp
//
//  Created by KKNANXX on 5/9/24.
//
//

import Foundation
import CoreData


extension InventorySection {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<InventorySection> {
        return NSFetchRequest<InventorySection>(entityName: "InventorySection")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var hasContainers: NSSet?
    @NSManaged public var toLocation: InventoryLocation?

}

// MARK: Generated accessors for hasContainers
extension InventorySection {

    @objc(addHasContainersObject:)
    @NSManaged public func addToHasContainers(_ value: InventoryContainer)

    @objc(removeHasContainersObject:)
    @NSManaged public func removeFromHasContainers(_ value: InventoryContainer)

    @objc(addHasContainers:)
    @NSManaged public func addToHasContainers(_ values: NSSet)

    @objc(removeHasContainers:)
    @NSManaged public func removeFromHasContainers(_ values: NSSet)

}

extension InventorySection : Identifiable {

}
