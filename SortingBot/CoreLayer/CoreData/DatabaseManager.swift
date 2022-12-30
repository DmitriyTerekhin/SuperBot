//
//  DatabaseManager.swift
//  SortingBot
//
//  Created by Дмитрий Терехин on 28.12.2022.
//

import Foundation
import CoreData

protocol IStorageManager: AnyObject {
    func saveResult(result: ActivityModel,
                    with context: NSManagedObjectContext,
                    completionHandler: FinishedCompletionHandler)
    func getResults(withPredicate: NSPredicate?, by context: NSManagedObjectContext) -> [ActivityModelDB]
    func deleteActivity(predicate: NSPredicate, by context: NSManagedObjectContext, completion: VoidCompletionHandler)
}

class DatabaseStorage: IStorageManager {
    func saveResult(result: ActivityModel,
                    with context: NSManagedObjectContext,
                    completionHandler: FinishedCompletionHandler) {
        context.performAndWait {
            _ = ActivityModelDB.insert(into: context, activityResult: result)
        }
        _ = context.saveOrRollback()
        completionHandler(true)
    }
    
    func getResults(withPredicate: NSPredicate?, by context: NSManagedObjectContext) -> [ActivityModelDB] {
        return ActivityModelDB.fetch(in: context, configurationBlock: { request in request.predicate = withPredicate})
    }
    
    func deleteActivity(predicate: NSPredicate, by context: NSManagedObjectContext, completion: VoidCompletionHandler) {
        guard let activity = ActivityModelDB.findOrFetch(in: context, matching: predicate) else { return }
        context.delete(activity)
        _ = context.saveOrRollback()
        completion()
    }
}
