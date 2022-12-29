//
//  NSManagedObjectContext.swift
//  SortingBot
//
//  Created by Дмитрий Терехин on 28.12.2022.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    
    func insertObject<A: NSManagedObject>() -> A where A: ManagedObjectType {
        guard let obj = NSEntityDescription.insertNewObject(forEntityName: A.entityName, into: self) as? A else { fatalError("Wrong object type") }
        return obj
    }
    
    func saveOrRollback() -> Bool {
        do {
            try save()
            _ = parent?.saveOrRollback()
            return true
        } catch {
            rollback()
            return false
        }
        
    }
    
    func performChanges(block: @escaping () -> Void) {
        perform {
            block()
            _ = self.saveOrRollback()
        }
    }
    
    func executeAndMergeChanges(using batchDeleteRequest: NSBatchDeleteRequest) throws {
        batchDeleteRequest.resultType = .resultTypeObjectIDs
        let result = try execute(batchDeleteRequest) as? NSBatchDeleteResult
        let changes: [AnyHashable: Any] = [NSDeletedObjectsKey: result?.result as? [NSManagedObjectID] ?? []]
        NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [self])
    }
}

// Для поиска одного объекта
private let singleObjectCacheKey = "SingleObjectCache"
private typealias SingleObjectCache = [String: NSManagedObject]

extension NSManagedObjectContext {
    
    public func set(_ object: NSManagedObject?, forSingleObjectCacheKey key: String) {
        var cache = userInfo[singleObjectCacheKey] as? SingleObjectCache ?? [:]
        cache[key] = object
        userInfo[singleObjectCacheKey] = cache
    }
    
    public func object(forSingleObjectCacheKey key: String) -> NSManagedObject? {
        guard let cache = userInfo[singleObjectCacheKey] as? [String: NSManagedObject] else { return nil }
        return cache[key]
    }
    
}
