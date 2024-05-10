//
//  Item+CoreDataProperties.swift
//  SmallBusinessInventoryApp
//
//  Created by KKNANXX on 5/9/24.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var photo: Data?
    @NSManaged public var itemdescription: String?
    @NSManaged public var ownershipstatus: Bool
    @NSManaged public var toContainer: Container?
    @NSManaged public var hasTags: NSSet?

}

// MARK: Generated accessors for hasTags
extension Item {

    @objc(addHasTagsObject:)
    @NSManaged public func addToHasTags(_ value: Tag)

    @objc(removeHasTagsObject:)
    @NSManaged public func removeFromHasTags(_ value: Tag)

    @objc(addHasTags:)
    @NSManaged public func addToHasTags(_ values: NSSet)

    @objc(removeHasTags:)
    @NSManaged public func removeFromHasTags(_ values: NSSet)

}

extension Item : Identifiable {

}
