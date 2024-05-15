//
//  Container+CoreDataProperties.swift
//  SmallBusinessInventoryApp
//
//  Created by KKNANXX on 5/14/24.
//
//

import Foundation
import CoreData


extension Container {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Container> {
        return NSFetchRequest<Container>(entityName: "Container")
    }

    @NSManaged public var name: String?
    @NSManaged public var hasItems: NSSet?
    @NSManaged public var toSection: Section?

}

// MARK: Generated accessors for hasItems
extension Container {

    @objc(addHasItemsObject:)
    @NSManaged public func addToHasItems(_ value: Item)

    @objc(removeHasItemsObject:)
    @NSManaged public func removeFromHasItems(_ value: Item)

    @objc(addHasItems:)
    @NSManaged public func addToHasItems(_ values: NSSet)

    @objc(removeHasItems:)
    @NSManaged public func removeFromHasItems(_ values: NSSet)

}

extension Container : Identifiable {

}
