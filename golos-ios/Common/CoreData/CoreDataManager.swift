//
//  CoreDataManager.swift
//  Golos
//
//  Created by msm72 on 03.07.2018.
//  Copyright © 2018 golos. All rights reserved.
//

import CoreData
import GoloSwift
import Foundation

class CoreDataManager {
    // MARK: - Properties. CoreDate Stack
    var modelName: String
    var sqliteName: String
    var options: NSDictionary?    

    var description: String {
        return "context: \(managedObjectContext)\n" + "modelName: \(modelName)" + "storeURL: \(applicationDocumentsDirectory)\n"
    }
    
    lazy var applicationDocumentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        return urls[urls.count - 1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL    =   Bundle.main.url(forResource: self.modelName, withExtension: "momd")!

        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator     =   NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url             =   self.applicationDocumentsDirectory.appendingPathComponent(self.sqliteName + ".sqlite")
        var failureReason   =   NSLocalizedString("CoreData saved error".localized(), comment: "")
        
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: self.options as! [AnyHashable: Any]?)
        }
        
        catch {
            var dict                                =   [String: AnyObject]()
            dict[NSLocalizedDescriptionKey]         =   NSLocalizedString("CoreData init error".localized(), comment: "") as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey]  =   failureReason as AnyObject?
            dict[NSUnderlyingErrorKey]              =   error as NSError
            let wrappedError                        =   NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            
            Logger.log(message: "Unresolved error \(wrappedError), \(wrappedError.userInfo)", event: .error)
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator                                     =   self.persistentStoreCoordinator
        var managedObjectContext                            =   NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator     =   coordinator
        managedObjectContext.mergePolicy                    =   NSMergeByPropertyObjectTrumpMergePolicy
        
        return managedObjectContext
    }()

    
    // MARK: - Class Initialization
    static let instance     =   CoreDataManager(modelName:  "GolosModels",
                                                sqliteName: "GolosModels",
                                                options:    [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true])
    
    private init(modelName: String, sqliteName: String, options: NSDictionary? = nil) {
        self.modelName      =   modelName
        self.sqliteName     =   sqliteName
        self.options        =   options
    }
    
    
    // MARK: - Class Functions
    /// Save context
    func saveContext() {
        do {
            try CoreDataManager.instance.managedObjectContext.save()
        } catch let error {
            Logger.log(message: "Unresolved error \((error as NSError).userInfo)", event: .error)
            abort()
        }
    }
    
    
    // MARK: - CRUD
    /// Create
    func createEntity(_ name: String) -> NSManagedObject {
        return NSEntityDescription.insertNewObject(forEntityName: name, into: managedObjectContext)
    }

    
    /// Read
    func readEntity(withName name: String, andPredicateParameters predicate: NSPredicate?) -> NSManagedObject? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)
        
        if predicate != nil {
            fetchRequest.predicate = predicate!
        }

        do {
            return try self.managedObjectContext.fetch(fetchRequest).first as? NSManagedObject
        }
        
        catch {
            Logger.log(message: "Read Entity '\(name)' failed", event: .error)
            return nil
        }
    }
    
    func readEntities(withName name: String, withPredicateParameters predicate: NSPredicate?, andSortDescriptor sortDescriptor: NSSortDescriptor?) -> [NSManagedObject]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)

        if predicate != nil {
            fetchRequest.predicate = predicate!
        }
        
        if sortDescriptor != nil {
            fetchRequest.sortDescriptors = [ sortDescriptor! ]
            fetchRequest.fetchLimit = 20
        }

        do {
            return try self.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
        }
        
        catch {
            Logger.log(message: "Read Entities '\(name)' failed", event: .error)
            return nil
        }
    }
    
   
    
    /// Clear main cache
    func clearCache() {
        let entitiesName = [ "ImageCached", "Lenta", "User" ]
        
        // Create Fetch Request
        for entityName in entitiesName {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            
            // Create Batch Delete Request
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            batchDeleteRequest.resultType = .resultTypeCount
           
            do {
                try managedObjectContext.execute(batchDeleteRequest)
            } catch let error {
                Logger.log(message: "Save deleted Entities '\(entityName)' failed: \((error as NSError).userInfo)", event: .error)
            }
        }
    }
    
    
    /// Delete
    func deleteEntities(withName name: String, andPredicateParameters predicate: NSPredicate?, completion: @escaping (Bool) -> Void) {
        let deleteFetchRequest                      =   NSFetchRequest<NSFetchRequestResult>(entityName: name)
        deleteFetchRequest.returnsObjectsAsFaults   =   false

        if predicate != nil {
            deleteFetchRequest.predicate            =   predicate!
        }
        
        do {
            let deletedEntities = try self.managedObjectContext.fetch(deleteFetchRequest)

            for deletedEntity in deletedEntities as! [NSManagedObject] {
                self.managedObjectContext.delete(deletedEntity)
            }
        }

        catch {
            Logger.log(message: "Delete Entities '\(name)' failed", event: .error)
            completion(false)
        }

        // Saving the Delete operation
        do {
            try self.managedObjectContext.save()
            completion(true)
        } catch {
            Logger.log(message: "Save deleted Entities '\(name)' failed", event: .error)
            completion(false)
        }
    }
}
