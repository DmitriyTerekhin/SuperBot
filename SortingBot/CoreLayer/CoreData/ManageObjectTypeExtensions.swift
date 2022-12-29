//
//  ManageObjectTypeExtensions.swift
//  SortingBot
//
//  Created by Дмитрий Терехин on 28.12.2022.
//

import Foundation
import CoreData

extension ManagedObjectType where Self: NSManagedObject {
    static func fetch(in context: NSManagedObjectContext, configurationBlock: (NSFetchRequest<Self>) -> Void = { _ in }) -> [Self] {
        let request = NSFetchRequest<Self>(entityName: Self.entityName)
        configurationBlock(request)
        
        do {
            return try context.fetch(request)
        } catch {
            return [Self]()
        }
    }
    
}

// Finding a particular object
extension ManagedObjectType where Self: NSManagedObject {
 
    static func findOrFetch(in context: NSManagedObjectContext, matching predicate: NSPredicate) -> Self? {
        guard let object = materializedObjectInContext(moc: context, matchingPredicate: predicate) else {
            return fetch(in: context) { request in
                request.predicate = predicate
                request.returnsObjectsAsFaults = false
                request.fetchLimit = 1
                }.first
        }
        return object
    }
    
    static func materializedObjectInContext(moc: NSManagedObjectContext, matchingPredicate predicate: NSPredicate) -> Self? {
        for obj in moc.registeredObjects where !obj.isFault {
            guard let res = obj as? Self, predicate.evaluate(with: res) else { continue }
            return res
        }
        return nil
    }
}

//For retrieving a single object
extension ManagedObjectType where Self: NSManagedObject {
    
    static func fetchSingleObjectInContext(moc: NSManagedObjectContext, cacheKey: String, configure: (NSFetchRequest<Self>) -> Void) -> Self? {
        
        if let cached = moc.object(forSingleObjectCacheKey: cacheKey) as? Self {
            return cached
        }
        
        let result = fetchSingleObject(in: moc, configure: configure)
        moc.set(result, forSingleObjectCacheKey: cacheKey)
        return result
    }
    
    private static func fetchSingleObject(in context: NSManagedObjectContext, configure: (NSFetchRequest<Self>) -> Void) -> Self? {
        
        let result = fetch(in: context) { request in
            configure(request)
            request.fetchLimit = 1
        }
        
        switch result.count {
        case 0: return nil
        case 1: return result[0]
        default: fatalError("Returned multiple objects, expected max 1")
        }
    }
}
