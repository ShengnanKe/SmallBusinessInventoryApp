//
//  DBManager.swift
//  SmallBusinessInventoryApp
//
//  Created by KKNANXX on 5/11/24.
//

/*
 CRUD
 - Create
 - Read
 - Update
 - Delete
 */

import Foundation
import CoreData
import UIKit

class DBManager: NSObject {
    
    static let shared: DBManager = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let container = appDelegate.persistentContainer
        return DBManager(context: container.viewContext)
    }()
    
    var managedContext: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.managedContext = context
        super.init()
    }
    
    func saveData() {
        let application = UIApplication.shared
        let appDelegate = application.delegate as? AppDelegate
        appDelegate?.saveContext()
    }
    
    // Create
    
    func addLocation(with dataModel: LocationModel) -> Bool {
        let location = Location(context: self.managedContext)
        location.id = dataModel.id
        location.name = dataModel.name
        
        do {
            try self.managedContext.save()
            return true
        } catch {
            print("Error saving location: \(error)")
            return false
        }
    }
    
    func addSection(with dataModel: SectionModel, location: Location) -> Bool {
        let section = Section(context: self.managedContext)
        section.id = dataModel.id
        section.name = dataModel.name
        section.toLocation = location
        
        do {
            try self.managedContext.save()
            return true
        } catch {
            print("Error saving section: \(error)")
            return false
        }
    }
    
    func addContainer(with dataModel: ContainerModel, section: Section) -> Bool {
        let container = Container(context: self.managedContext)
        container.id = dataModel.id
        container.name = dataModel.name
        container.toSection = section
        
        do {
            try self.managedContext.save()
            return true
        } catch {
            print("Error saving container: \(error)")
            return false
        }
    }
    
    func addItem(with dataModel: ItemModel, container: Container, tag: Tag?) -> Bool { // 可以没有tag -> 可能需要改一下
        let item = Item(context: self.managedContext)
        item.id = dataModel.id
        item.name = dataModel.name
        item.itemdescription = dataModel.itemDescription
        item.ownershipstatus = dataModel.ownershipStatus
        item.photo = dataModel.photo
        item.toContainer = container
        item.hasTag = tag
        
        do {
            try self.managedContext.save()
            return true
        } catch {
            print("Error saving item: \(error)")
            return false
        }
    }
    
    func addTag(with dataModel: TagModel) -> Bool {
        let tag = Tag(context: self.managedContext)
        tag.id = dataModel.id
        tag.name = dataModel.name
        
        do {
            try self.managedContext.save()
            return true
        } catch {
            print("Error saving tag: \(error)")
            return false
        }
    }
    
    
    // Read -> fetch 这个是fetch所有东西的 所以这个不对
    /*
     func fetchData(entityName: String) -> [NSManagedObject] {
     let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
     
     do {
     // Try to fetch the entities and return the results
     let fetchResult = try self.managedContext.fetch(fetchRequest)
     return fetchResult
     } catch {
     print("Error fetching \(entityName): \(error)")
     return []
     }
     }
     */
    // let items = fetchData(entityName: "Item") as? [Item] ?? []
    // let locations = fetchData(entityName: "Location") as? [Location] ?? []
    
    
    
    // Read -> fetch
    
    // with fetchAllEntities
    func fetchAllEntities<T: NSManagedObject>(entityName: String) -> [T] {
        let fetchRequest = NSFetchRequest<T>(entityName: entityName)
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            print("Fetched \(results.count) entities of type \(entityName)")
            return results
        } catch {
            print("Error fetching all \(entityName): \(error)")
            return []
        }
    }
    
    // for section vc
    func fetchSections(for location: Location) -> [Section] {
        let fetchRequest: NSFetchRequest<Section> = Section.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "toLocation == %@", location)

        do {
            let results = try managedContext.fetch(fetchRequest)
            print("Fetched \(results.count) sections for location: \(location.name ?? "Unknown")")
            return results
        } catch {
            print("Error fetching sections for location \(location.name ?? "Unknown"): \(error)")
            return []
        }
    }
    
    // for container vc
    func fetchContainers(for section: Section) -> [Container] {
        let fetchRequest: NSFetchRequest<Container> = Container.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "toSection == %@", section)
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            print("Fetched \(results.count) containers for section: \(section.name ?? "Unknown")")
            return results
        } catch {
            print("Error fetching containers for section \(section.name ?? "Unknown"): \(error)")
            return []
        }
    }
    
    // for item vc
    func fetchItems(for container: Container) -> [Item] {
        let containerID = container.objectID
        guard let fetchedContainer = try? managedContext.existingObject(with: containerID) as? Container else {
            print("Container not found in context.")
            return []
        }
        
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "toContainer == %@", container)
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            print("Fetched \(results.count) items for container: \(container.name ?? "Unknown")")
            return results
        } catch {
            print("Error fetching items for container \(container.name ?? "Unknown"): \(error)")
            return []
        }
    }


    func fetchData<T: NSManagedObject>(entityName: String, attribute: String, value: Any) -> [T] {
        let fetchRequest = NSFetchRequest<T>(entityName: entityName)
        
        let predicate: NSPredicate
        switch value {
        case let stringValue as String:
            predicate = NSPredicate(format: "%K == %@", attribute, stringValue)
        case let intValue as Int:
            predicate = NSPredicate(format: "%K == %d", attribute, intValue)
        case let boolValue as Bool:
            predicate = NSPredicate(format: "%K == %@", attribute, NSNumber(value: boolValue))
        case let uuidValue as UUID:
            predicate = NSPredicate(format: "%K == %@", attribute, uuidValue as CVarArg)
        default:
            print("Unhandled type of value \(type(of: value)); using a default predicate that matches none.")
            predicate = NSPredicate(value: false)
        }
        
        fetchRequest.predicate = predicate
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            return results
        } catch {
            print("Error fetching \(entityName): \(error)")
            return []
        }
    }
    
    //    func fetchData(entityName: String, attribute: String, value: Any) -> [NSManagedObject] {
    //        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
    //
    //        let predicate = NSPredicate(format: "%K == %@", attribute, value as! CVarArg) // NSPredicate(format: "name == %@", "SpecificName")
    //        fetchRequest.predicate = predicate
    //
    //            do {
    //                let results = try managedContext.fetch(fetchRequest)
    //                return results
    //            } catch {
    //                print("Error fetching \(entityName): \(error)")
    //                return []
    //            }
    //    }
    
    // Update item 就行
//    func updateLocation(id: UUID, newName: String) -> Bool {
//        let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
//        do {
//            let results = try self.managedContext.fetch(fetchRequest)
//            if let locationToUpdate = results.first {
//                locationToUpdate.name = newName // setvalue
//                saveData()
//                return true
//            }
//        } catch {
//            print("Error updating location: \(error)")
//        }
//        return false
//    }
//    
//    func updateSection(id: UUID, newName: String) -> Bool {
//        let fetchRequest: NSFetchRequest<Section> = Section.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
//        do {
//            let results = try self.managedContext.fetch(fetchRequest)
//            if let sectionToUpdate = results.first {
//                sectionToUpdate.name = newName
//                saveData()
//                return true
//            }
//        } catch {
//            print("Error updating section: \(error)")
//        }
//        return false
//    }
//    
//    func updateContainer(id: UUID, newName: String) -> Bool {
//        let fetchRequest: NSFetchRequest<Container> = Container.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
//        do {
//            let results = try self.managedContext.fetch(fetchRequest)
//            if let containerToUpdate = results.first {
//                containerToUpdate.name = newName
//                saveData()
//                return true
//            }
//        } catch {
//            print("Error updating container: \(error)")
//        }
//        return false
//    }
    
    func updateItem(id: UUID, newName: String?, newItemDescription: String?, newOwnershipStatus: Bool?, newPhoto: String?) -> Bool {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        do {
            let results = try self.managedContext.fetch(fetchRequest)
            if let itemToUpdate = results.first {
                if let newName = newName {
                    itemToUpdate.name = newName
                }
                if let newItemDescription = newItemDescription {
                    itemToUpdate.itemdescription = newItemDescription
                }
                if let newOwnershipStatus = newOwnershipStatus {
                    itemToUpdate.ownershipstatus = newOwnershipStatus
                }
                if let newPhoto = newPhoto {
                    itemToUpdate.photo = newPhoto
                }
                saveData()
                return true
            }
        } catch {
            print("Error updating item: \(error)")
        }
        return false
    }
    
//    func updateTag(id: UUID, newName: String) -> Bool {
//        let fetchRequest: NSFetchRequest<Tag> = Tag.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
//        do {
//            let results = try self.managedContext.fetch(fetchRequest)
//            if let tagToUpdate = results.first {
//                tagToUpdate.name = newName
//                saveData()
//                return true
//            }
//        } catch {
//            print("Error updating tag: \(error)")
//        }
//        return false
//    }
    
    // Delete
    
    func deleteEntity(entityName: String, id: UUID) -> Bool {
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest<NSManagedObject>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            if let entityToDelete = results.first {
                managedContext.delete(entityToDelete)
                saveData()
                return true
            }
        } catch {
            print("Error deleting \(entityName): \(error)")
        }
        return false
    }

    
    func preloadDataIfNeeded() {
        let hasPreloadedData = UserDefaults.standard.bool(forKey: "hasPreloadedData")
        if !hasPreloadedData {
            preloadLocationsSectionsContainersTags()
            UserDefaults.standard.set(true, forKey: "hasPreloadedData")
            UserDefaults.standard.synchronize()
        }
    }
    
    func preloadLocationsSectionsContainersTags() {
        
        let location1 = LocationModel(id: UUID(), name: "Main Warehouse")
        let location2 = LocationModel(id: UUID(), name: "Secondary Storage")
        let location3 = LocationModel(id: UUID(), name: "Third Storage")
        _ = addLocation(with: location1)
        _ = addLocation(with: location2)
        _ = addLocation(with: location3)
        
        guard let mainWarehouse = fetchData(entityName: "Location", attribute: "name", value: "Main Warehouse").first as? Location,
              let secondaryStorage = fetchData(entityName: "Location", attribute: "name", value: "Secondary Storage").first as? Location,
              let thirdStorage = fetchData(entityName: "Location", attribute: "name", value: "Third Storage").first as? Location else {
            print("Error: Predefined locations not found.")
            return
        }
        
        
        let section1 = SectionModel(id: UUID(), name: "Green")
        let section2 = SectionModel(id: UUID(), name: "Blue")
        let section3 = SectionModel(id: UUID(), name: "Pink")
        
        _ = addSection(with: section1, location: mainWarehouse)
        _ = addSection(with: section2, location: secondaryStorage)
        _ = addSection(with: section3, location: thirdStorage)
        
        guard let greenSection = fetchData(entityName: "Section", attribute: "name", value: "Green").first as? Section,
              let blueSection = fetchData(entityName: "Section", attribute: "name", value: "Blue").first as? Section,
              let pinkSection = fetchData(entityName: "Section", attribute: "name", value: "Pink").first as? Section else {
            print("Error: Predefined sections not found.")
            return
        }
        
        
        let container1 = ContainerModel(id: UUID(), name: "Shelf 1")
        let container2 = ContainerModel(id: UUID(), name: "Shelf 2")
        let container3 = ContainerModel(id: UUID(), name: "Shelf 3")
        
        _ = addContainer(with: container1, section: greenSection)
        _ = addContainer(with: container2, section: blueSection)
        _ = addContainer(with: container3, section: pinkSection)
        
        
        let tag1 = TagModel(id: UUID(), name: "Monday")
        let tag2 = TagModel(id: UUID(), name: "Tuesday")
        let tag3 = TagModel(id: UUID(), name: "Wednesday")
        
        _ = addTag(with: tag1)
        _ = addTag(with: tag2)
        _ = addTag(with: tag3)
    }
    
    
    
}

extension DBManager {
    
    // for the search item vc
    func fetchItems(matching query: String) -> [Item] {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        // earch by name, description, and tags
        let namePredicate = NSPredicate(format: "name CONTAINS[cd] %@", query)
        let descriptionPredicate = NSPredicate(format: "itemdescription CONTAINS[cd] %@", query)
        let tagPredicate = NSPredicate(format: "hasTag.name CONTAINS[cd] %@", query)
        
        request.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [namePredicate, descriptionPredicate, tagPredicate])

        do {
            return try managedContext.fetch(request)
        } catch {
            print("Error fetching data: \(error)")
            return []
        }
    }
}
