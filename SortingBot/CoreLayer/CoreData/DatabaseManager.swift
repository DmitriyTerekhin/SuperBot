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
}
