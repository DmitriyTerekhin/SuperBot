//
//  ActivityModelEntity.swift
//  SortingBot
//
//  Created by Дмитрий Терехин on 28.12.2022.
//

import Foundation
import CoreData

@objc(ActivityModel)
public final class ActivityModelDB: NSManagedObject {
    
    @NSManaged public private(set) var image: Data?
    @NSManaged public private(set) var urgent: Int16
    @NSManaged public private(set) var important: Int16
    @NSManaged public private(set) var name: String
    
    static func insert(into context: NSManagedObjectContext, activityResult: ActivityModel) -> ActivityModelDB {
        let activityDB: ActivityModelDB = context.insertObject()
        activityDB.image = activityResult.image
        activityDB.urgent = Int16(activityResult.howUrgent)
        activityDB.important = Int16(activityResult.howImportant)
        activityDB.name = activityResult.name
        return activityDB
    }
}

extension ActivityModelDB: ManagedObjectType {
    static var entityName: String {
        "ActivityModel"
    }
}
