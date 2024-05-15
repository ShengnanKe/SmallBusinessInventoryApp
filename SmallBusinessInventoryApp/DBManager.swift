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
    
    
    func saveData() -> Bool {
        let application = UIApplication.shared
        let appDelegate = application.delegate as? AppDelegate
        appDelegate?.saveContext()
        return true
    }
    
    func addLocation(with dataModel: LocationModel) -> Bool {
        guard let entity = NSEntityDescription.entity(forEntityName: "Location", in: self.managedContext) else {
            print("Failed to create entity description for Location")
            return false
        }
        let location = NSManagedObject(entity: entity, insertInto: self.managedContext)
        location.setValue(dataModel.name, forKey: "name")
        
        return saveData()
    }
    
    func addSection(with name: String, to location: Location) -> Bool {
        guard let entity = NSEntityDescription.entity(forEntityName: "Section", in: managedContext) else {
            print("Failed to create entity description for Section")
            return false
        }
        let section = NSManagedObject(entity: entity, insertInto: managedContext)
        section.setValue(name, forKey: "name")
        section.setValue(location, forKey: "toLocation")
        return saveData()
    }
    
    func addContainer(with name: String, to section: Section) -> Bool {
        guard let entity = NSEntityDescription.entity(forEntityName: "Container", in: managedContext) else {
            print("Failed to create entity description for Container")
            return false
        }
        let container = NSManagedObject(entity: entity, insertInto: managedContext)
        container.setValue(name, forKey: "name")
        container.setValue(section, forKey: "toSection")
        return saveData()
    }
    
    func addItem(with dataModel: ItemModel, container: Container, tag: Tag?) -> Bool { // 可以没有tag -> 可能需要改一下
        let item = Item(context: self.managedContext)
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
    
    func addTag(with name: String) -> Bool {
        guard let entity = NSEntityDescription.entity(forEntityName: "Tag", in: managedContext) else {
            print("Failed to create entity description for Tag")
            return false
        }
        let tag = NSManagedObject(entity: entity, insertInto: managedContext)
        tag.setValue(name, forKey: "name")
        return saveData()
    }
    
    // Read -> fetch
    
    func fetchAllEntities<T: NSManagedObject>(entityName: String) -> [T] {
        let fetchRequest = NSFetchRequest<T>(entityName: entityName)
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            print("Fetched \(results.count) entities of type \(entityName)")
            return results
        } catch {
            print("Error fetching \(entityName): \(error)")
            return []
        }
    }
    
    func fetchSections(for location: Location) -> [Section] {
        return location.hasSections?.allObjects as? [Section] ?? []
    }
    
    func fetchContainers(for section: Section) -> [Container] {
        return section.hasContainers?.allObjects as? [Container] ?? []
    }
    
    func fetchItems(for container: Container) -> [Item] {
        return container.hasItems?.allObjects as? [Item] ?? []
    }
    
    func fetchData<T: NSManagedObject>(entityName: String, attribute: String, value: Any) -> [T] {
        let fetchRequest = NSFetchRequest<T>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "%K == %@", attribute, value as! CVarArg)
        
        do {
            return try managedContext.fetch(fetchRequest)
        } catch {
            print("Error fetching \(entityName): \(error)")
            return []
        }
    }
    
    func updateItem(oldName: String, newName: String?, newItemDescription: String?, newOwnershipStatus: Bool?, newPhoto: String?) -> Bool {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", oldName)
        do {
            let results = try managedContext.fetch(fetchRequest)
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
    
    // Delete
    
    func deleteEntity(entityName: String, name: String) -> Bool {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
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
    
    private func saveContext() -> Bool {
        do {
            try managedContext.save()
            return true
        } catch {
            print("Error saving context: \(error)")
            return false
        }
    }
    
}

extension DBManager {
    
    // for the search item vc
    func fetchItems(matching query: String) -> [Item] {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        let namePredicate = NSPredicate(format: "name CONTAINS[cd] %@", query)
        let descriptionPredicate = NSPredicate(format: "itemdescription CONTAINS[cd] %@", query)
        let tagPredicate = NSPredicate(format: "hasTag.name CONTAINS[cd] %@", query)
        request.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [namePredicate, descriptionPredicate, tagPredicate])
        
        do {
            return try managedContext.fetch(request)
        } catch {
            print("Error fetching items matching \(query): \(error)")
            return []
        }
    }
}
