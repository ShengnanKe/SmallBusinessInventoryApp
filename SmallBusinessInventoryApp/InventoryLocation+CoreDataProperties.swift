//
//  InventoryLocation+CoreDataProperties.swift
//  SmallBusinessInventoryApp
//
//  Created by KKNANXX on 5/9/24.
//
//

import Foundation
import CoreData


extension InventoryLocation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<InventoryLocation> {
        return NSFetchRequest<InventoryLocation>(entityName: "InventoryLocation")
    }

    @NSManaged public var name: String?
    @NSManaged public var id: UUID?
    @NSManaged public var hasSections: NSSet?

}

// MARK: Generated accessors for hasSections
extension InventoryLocation {

    @objc(addHasSectionsObject:)
    @NSManaged public func addToHasSections(_ value: InventorySection)

    @objc(removeHasSectionsObject:)
    @NSManaged public func removeFromHasSections(_ value: InventorySection)

    @objc(addHasSections:)
    @NSManaged public func addToHasSections(_ values: NSSet)

    @objc(removeHasSections:)
    @NSManaged public func removeFromHasSections(_ values: NSSet)

}

extension InventoryLocation : Identifiable {

}
