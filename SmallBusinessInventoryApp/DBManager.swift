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
    
    func addItem(with dataModel: ItemModel, container: Container, tag: Tag) -> Bool {
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
    func fetchData(entityName: String, attribute: String, value: Any) -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        
        if let cvarValue = value as? CVarArg {
            let predicate = NSPredicate(format: "%K == %@", attribute, cvarValue)
            fetchRequest.predicate = predicate
            
            do {
                let results = try managedContext.fetch(fetchRequest)
                return results
            } catch {
                print("Error fetching \(entityName): \(error)")
                return []
            }
        } else {
            print("Error: Value does not conform to CVarArg")
            return []
        }
    }
    
    // Update
    func updateLocation(id: UUID, newName: String) -> Bool {
        let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        do {
            let results = try self.managedContext.fetch(fetchRequest)
            if let locationToUpdate = results.first {
                locationToUpdate.name = newName // setvalue
                saveData()
                return true
            }
        } catch {
            print("Error updating location: \(error)")
        }
        return false
    }
    
    func updateSection(id: UUID, newName: String) -> Bool {
        let fetchRequest: NSFetchRequest<Section> = Section.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        do {
            let results = try self.managedContext.fetch(fetchRequest)
            if let sectionToUpdate = results.first {
                sectionToUpdate.name = newName
                saveData()
                return true
            }
        } catch {
            print("Error updating section: \(error)")
        }
        return false
    }
    
    func updateContainer(id: UUID, newName: String) -> Bool {
        let fetchRequest: NSFetchRequest<Container> = Container.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        do {
            let results = try self.managedContext.fetch(fetchRequest)
            if let containerToUpdate = results.first {
                containerToUpdate.name = newName
                saveData()
                return true
            }
        } catch {
            print("Error updating container: \(error)")
        }
        return false
    }
    
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
    
    func updateTag(id: UUID, newName: String) -> Bool {
        let fetchRequest: NSFetchRequest<Tag> = Tag.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        do {
            let results = try self.managedContext.fetch(fetchRequest)
            if let tagToUpdate = results.first {
                tagToUpdate.name = newName
                saveData()
                return true
            }
        } catch {
            print("Error updating tag: \(error)")
        }
        return false
    }
    
    // Delete
    
    func deleteEntity(entityName: String, id: UUID) -> Bool {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg) //delete things based on the id
        
        do {
            let results = try self.managedContext.fetch(fetchRequest)
            if let entityToDelete = results.first {
                self.managedContext.delete(entityToDelete)
                saveData()
                return true
            }
        } catch {
            print("Error deleting \(entityName): \(error)")
        }
        return false
    }
    
    
    
    func addPersistentStore() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("Failed to retrieve AppDelegate")
            return
        }
        
        let container = appDelegate.persistentContainer
        let storeCoordinator = container.persistentStoreCoordinator
        
        let defaultURL = NSPersistentContainer.defaultDirectoryURL()
        let storeURL = defaultURL.appendingPathComponent("BusinessInventory.sqlite")
        
        do {
            let store = try storeCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
            print("Store added successfully: \(store)")
        } catch {
            print("Failed to add persistent store: \(error)")
        }
    }
    
    
    
    func preloadDataIfNeeded() {
        let hasPreloadedData = UserDefaults.standard.bool(forKey: "hasPreloadedData")
        if !hasPreloadedData {
            preloadLocationsSectionsContainers()
            UserDefaults.standard.set(true, forKey: "hasPreloadedData")
            UserDefaults.standard.synchronize()
        }
    }
    
    private func preloadLocationsSectionsContainers() {
        
        let location1 = LocationModel(id: UUID(), name: "Main Warehouse")
        let location2 = LocationModel(id: UUID(), name: "Secondary Storage")
        _ = addLocation(with: location1)
        _ = addLocation(with: location2)
        
        guard let mainWarehouse = fetchData(entityName: "Location", attribute: "name", value: "Main Warehouse").first as? Location,
              let secondaryStorage = fetchData(entityName: "Location", attribute: "name", value: "Secondary Storage").first as? Location else {
            print("Error: Predefined locations not found.")
            return
        }
        
        let section1 = SectionModel(id: UUID(), name: "Electronics")
        let section2 = SectionModel(id: UUID(), name: "Clothing")
        _ = addSection(with: section1, location: mainWarehouse)
        _ = addSection(with: section2, location: secondaryStorage)
        
        guard let electronicsSection = fetchData(entityName: "Section", attribute: "name", value: "Electronics").first as? Section,
              let clothingSection = fetchData(entityName: "Section", attribute: "name", value: "Clothing").first as? Section else {
            print("Error: Predefined sections not found.")
            return
        }
        
        let container1 = ContainerModel(id: UUID(), name: "Shelf 1")
        let container2 = ContainerModel(id: UUID(), name: "Rack 1")
        _ = addContainer(with: container1, section: electronicsSection)
        _ = addContainer(with: container2, section: clothingSection)
        
        let tag1 = TagModel(id: UUID(), name: "Urgent")
        let tag2 = TagModel(id: UUID(), name: "Review")
        _ = addTag(with: tag1)
        _ = addTag(with: tag2)
    }
    
    
    
}

