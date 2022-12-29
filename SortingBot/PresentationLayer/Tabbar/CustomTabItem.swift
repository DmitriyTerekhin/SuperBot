//
//  CustomTabItem.swift
//  SortingBot
//
//  Created by Дмитрий Терехин on 27.12.2022.
//

import UIKit

enum CustomTabItemType {
    case create
    case history
    case settings
}

struct CustomTabItem: Equatable {
    let type: CustomTabItemType
    let viewController: UIViewController
    
    var icon: UIImage? {
        type.icon
    }
    
    var selectedIcon: UIImage? {
        type.selectedIcon
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.type == rhs.type
    }
}

extension CustomTabItemType {

    var icon: UIImage? {
        switch self {
        case .create:
            return UIImage(named: "CreateActivityTab")
        case .history:
            return UIImage(named: "ActivityHistoryTab")
        case .settings:
            return UIImage(named: "SettingsTab")
        }
    }

    var selectedIcon: UIImage? {
        switch self {
        case .create:
            return UIImage(named: "CreateActivityActive")
        case .history:
            return UIImage(named: "HistoryTabActive")
        case .settings:
            return UIImage(named: "SettingsTabActive")
        }
    }
    
    var title: String {
        switch self {
        case .create:
            return ""
        case .history:
            return ""
        case .settings:
            return ""
        }
    }
}
