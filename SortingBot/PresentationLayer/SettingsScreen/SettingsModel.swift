//
//  SettingsModel.swift
//  SortingBot
//
//  Created by Дмитрий Терехин on 27.12.2022.
//

import Foundation

enum SettingType: CaseIterable {
    case buyPremium
    case feedback
    case privacy
    case terms
    case restorePurchases
    case deleteAccount
    
    var title: String {
        switch self {
        case .buyPremium:
            return "Buy premium"
        case .feedback:
            return "Send feedback"
        case .privacy:
            return "Privacy policy"
        case .terms:
            return "Terms of use"
        case .restorePurchases:
            return "Restore purchase"
        case .deleteAccount:
            return "Delete account"
        }
    }
}
