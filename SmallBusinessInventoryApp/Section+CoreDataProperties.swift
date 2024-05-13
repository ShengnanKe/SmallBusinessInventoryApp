//
//  Section+CoreDataProperties.swift
//  SmallBusinessInventoryApp
//
//  Created by KKNANXX on 5/12/24.
//
//

import Foundation
import CoreData


extension Section {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Section> {
        return NSFetchRequest<Section>(entityName: "Section")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var hasContainers: NSSet?
    @NSManaged public var toLocation: Location?

}

// MARK: Generated accessors for hasContainers
extension Section {

    @objc(addHasContainersObject:)
    @NSManaged public func addToHasContainers(_ value: Container)

    @objc(removeHasContainersObject:)
    @NSManaged public func removeFromHasContainers(_ value: Container)

    @objc(addHasContainers:)
    @NSManaged public func addToHasContainers(_ values: NSSet)

    @objc(removeHasContainers:)
    @NSManaged public func removeFromHasContainers(_ values: NSSet)

}

extension Section : Identifiable {

}
