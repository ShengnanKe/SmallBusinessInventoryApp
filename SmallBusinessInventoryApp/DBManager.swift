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
    
}




/*
 
 func saveDataToStudent(withEntity: String, with dataModel: StudentModel) -> Bool {
 if let entity = NSEntityDescription.entity(forEntityName: withEntity, in: self.managedContext) {
 let user = NSManagedObject(entity: entity, insertInto: self.managedContext)
 
 user.setValue(dataModel.name, forKey: "name")
 user.setValue(dataModel.age, forKey: "age")
 user.setValue(dataModel.email, forKey: "email")
 
 //            saveData()
 // return true
 do {
 try self.managedContext.save()
 return true
 }
 catch {
 print(error)
 }
 }
 
 return false
 
 }
 
 func saveData() {
 let application = UIApplication.shared
 let appDelegate = application.delegate as? AppDelegate
 appDelegate?.saveContext()
 }
 
 func fetchData(withEntity: String) -> [NSManagedObject] {
 var fetchResult: [NSManagedObject] = []
 
 let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: withEntity)
 
 do {
 fetchResult = try self.managedContext.fetch(fetchRequest) as? [NSManagedObject] ?? []
 
 return fetchResult
 }
 catch {
 print(error)
 }
 
 return []
 }
 
 func updateData(withEntity: String, with dataModel: SmallBusinessInventoryApp) -> Bool
 {
 var fetchResult: [NSManagedObject] = []
 
 let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: withEntity)
 fetchRequest.fetchLimit = 1
 
 do {
 fetchResult = try self.managedContext.fetch(fetchRequest) as? [NSManagedObject] ?? []
 if fetchResult.count > 0 {
 let obj = fetchResult[0] as NSManagedObject
 obj.setValue(dataModel.name, forKey: "name")
 obj.setValue(dataModel.age, forKey: "age")
 obj.setValue(dataModel.email, forKey: "email")
 }
 saveData()
 return true
 }
 catch {
 print(error)
 }
 
 return false
 }
 
 func deleteData(withEntity: String) -> Bool {
 var fetchResult: [NSManagedObject] = []
 
 let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: withEntity)
 fetchRequest.fetchLimit = 1
 
 do {
 fetchResult = try self.managedContext.fetch(fetchRequest) as? [NSManagedObject] ?? []
 if fetchResult.count > 0 {
 let obj = fetchResult[0] as NSManagedObject
 self.managedContext.delete(obj)
 }
 saveData()
 return true
 }
 catch {
 print(error)
 }
 
 return false
 }
 
 
 func addPersitentStore()
 {
 let application = UIApplication.shared
 let appDelegate = application.delegate as? AppDelegate
 let container = appDelegate?.persistentContainer
 
 let storeCordinator = container?.persistentStoreCoordinator
 
 let defaultURL = NSPersistentContainer.defaultDirectoryURL()
 
 let storeURL = defaultURL.appendingPathComponent("Sample.sqlite")
 
 do {
 let store = try storeCordinator?.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
 }
 catch {
 print(error)
 }
 
 
 }
 */

