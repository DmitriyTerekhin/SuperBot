//
//  CreateActivityModels.swift
//  SortingBot
//
//  Created by Дмитрий Терехин on 27.12.2022.
//

import Foundation

enum CreateActivityViewState {
    case start
    case creatingActivity
    case addingPoints
    case finalResult
}

class ActivityModel {
    var image: Data?
    var name: String = ""
    var howImportant: Int = 1
    var howUrgent: Int = 1
    
    init() {}
    
    init(image: Data? = nil, name: String, howImportant: Int, howUrgent: Int) {
        self.image = image
        self.name = name
        self.howImportant = howImportant
        self.howUrgent = howUrgent
    }
}
