//
//  Location+CoreDataProperties.swift
//  SmallBusinessInventoryApp
//
//  Created by KKNANXX on 5/9/24.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var name: String?
    @NSManaged public var id: UUID?
    @NSManaged public var hasSections: NSSet?

}

// MARK: Generated accessors for hasSections
extension Location {

    @objc(addHasSectionsObject:)
    @NSManaged public func addToHasSections(_ value: Section)

    @objc(removeHasSectionsObject:)
    @NSManaged public func removeFromHasSections(_ value: Section)

    @objc(addHasSections:)
    @NSManaged public func addToHasSections(_ values: NSSet)

    @objc(removeHasSections:)
    @NSManaged public func removeFromHasSections(_ values: NSSet)

}

extension Location : Identifiable {

}
