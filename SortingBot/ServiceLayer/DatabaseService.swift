//
//  DatabaseService.swift
//  SortingBot
//
//  Created by Дмитрий Терехин on 28.12.2022.
//

import Foundation
import CoreData

protocol IDatabaseService {
    func saveResult(result: ActivityModel, completionHandler: FinishedCompletionHandler)
    func getActivities(predicate: NSPredicate?) -> [ActivityModel]
    func deleteActivity(predicate: NSPredicate, completion: VoidCompletionHandler)
}

class DatabaseService: IDatabaseService {
    
    func saveResult(result: ActivityModel, completionHandler: FinishedCompletionHandler) {
        db.saveResult(result: result, with: CDStack.mainContext, completionHandler: completionHandler)
    }
    
    func getActivities(predicate: NSPredicate?) -> [ActivityModel] {
        db.getResults(withPredicate: predicate,
                      by: CDStack.mainContext).map({
            ActivityModel(image: $0.image,
                          name: $0.name,
                          howImportant: Int($0.important),
                          howUrgent: Int($0.urgent))
        })
    }
    
    func deleteActivity(predicate: NSPredicate, completion: VoidCompletionHandler) {
        db.deleteActivity(predicate: predicate, by: CDStack.mainContext, completion: completion)
    }
    
    private let db: IStorageManager
    private let CDStack: ICoreDataStack
    
    init(db: IStorageManager, coreDataStack: ICoreDataStack) {
        self.db = db
        self.CDStack = coreDataStack
    }
}
