//
//  HttpDBCache.swift
//  AppleDevelopTools
//
//  Created by 孙俊 on 2021/5/10.
//

import Foundation
import CoreData

open class HttpDBCache : HttpBaseCache {

    fileprivate var managedObjectModel: NSManagedObjectModel
    fileprivate var persistentStoreCoordinator: NSPersistentStoreCoordinator
    fileprivate var managedObjectContext: NSManagedObjectContext

    fileprivate var tempContext: NSManagedObjectContext?

    override var cacheSize: Int {
        return 0
    }

    public init(managedObjectModel model: NSManagedObjectModel, persistentStoreCoordinator coordinator: NSPersistentStoreCoordinator, managedObjectContext context: NSManagedObjectContext) {

        self.managedObjectModel = model
        self.persistentStoreCoordinator = coordinator
        self.managedObjectContext = context
    }

    //MARK: - Public Method
    override func clearCache() {
        let fetch: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "HttpCache")

        do {
            let entityArray = try self.managedObjectContext.fetch(fetch)
            if entityArray.count == 0 {
                return
            }
            for entity in entityArray {
                let saveContext = getTempContext()
                saveContext.delete(entity as! NSManagedObject)
            }
        } catch {
            let nserror = error as NSError
            print("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        self.saveContext()
    }

    override func removeObjectForKey(aKey: String) {
        let entity = self.getDBEntity(aKey)
        if entity != nil {
            let saveContext = getTempContext()
            saveContext.delete(entity!)
            self.saveContext()
        }
    }

    override subscript(aKey:String) -> Data? {
        get {
            let entity = self.getDBEntity(aKey)
            if entity != nil {
                let responseData = entity!.value(forKey: "response")
                return responseData as? Data
            }
            return nil
        }
        set {
            if newValue == nil {
                print("试图存入一个空的内容到数据库缓存，操作被忽略")
                return
            }
            let oldEntity = self.getDBEntity(aKey)
            if oldEntity != nil {
                oldEntity!.setValue(newValue, forKey: "response")
            } else {
                let saveContext = getTempContext()
                let newEntity = NSEntityDescription.insertNewObject(forEntityName: "HttpCache", into: saveContext)
                newEntity.setValue(aKey, forKey: "key")
                newEntity.setValue(newValue!, forKey: "response")
            }
            self.saveContext()
        }
    }

    //MARK: - Private Method
    fileprivate func getDBEntity(_ aKey: String) -> NSManagedObject? {

        let fetch: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "HttpCache")
        fetch.predicate = NSPredicate(format: "key=%@", argumentArray: [aKey])

        do {
            let saveContext = getTempContext()
            let entityArray = try saveContext.fetch(fetch)
            if entityArray.count == 0 {
                return nil
            }
            let dbObject = entityArray[0] as! NSManagedObject
            return dbObject
        } catch {
            return nil;
        }
    }

    fileprivate func getTempContext() -> NSManagedObjectContext {
        if self.tempContext != nil {
            return self.tempContext!
        }
        self.tempContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        self.tempContext!.parent = self.managedObjectContext
        return self.tempContext!
    }

    // MARK: - Core Data Saving support
    fileprivate func saveContext () {
        let saveContext = getTempContext()
        if saveContext.hasChanges {
            print("子Context已经改变")
            saveContext.performAndWait({
                do {
                    try saveContext.save()
                    print("主Context已经改变")
                    try self.managedObjectContext.save()
                } catch {
                    let nserror = error as NSError
                    print("Unresolved error \(nserror), \(nserror.userInfo)")
                    abort()
                }
            })
        }
    }
}
