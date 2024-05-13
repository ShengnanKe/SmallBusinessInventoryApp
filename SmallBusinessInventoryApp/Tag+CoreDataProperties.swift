//
//  Tag+CoreDataProperties.swift
//  SmallBusinessInventoryApp
//
//  Created by KKNANXX on 5/12/24.
//
//

import Foundation
import CoreData


extension Tag {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tag> {
        return NSFetchRequest<Tag>(entityName: "Tag")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var toItems: NSSet?

}

// MARK: Generated accessors for toItems
extension Tag {

    @objc(addToItemsObject:)
    @NSManaged public func addToToItems(_ value: Item)

    @objc(removeToItemsObject:)
    @NSManaged public func removeFromToItems(_ value: Item)

    @objc(addToItems:)
    @NSManaged public func addToToItems(_ values: NSSet)

    @objc(removeToItems:)
    @NSManaged public func removeFromToItems(_ values: NSSet)

}

extension Tag : Identifiable {

}
