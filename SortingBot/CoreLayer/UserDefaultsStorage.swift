//
//  UserDefaultsStorage.swift
//  SortingBot
//
//  Created by Дмитрий Терехин on 26.12.2022.
//

import Foundation
import SwiftyUserDefaults

protocol IUserDefaultsSettings {
    func changeUserInAppValue(on: Bool)
    func getUserInAppValue() -> Bool
    func changePushAsked(value: Bool)
    func getAskPushValue() -> Bool
}

class UserDefaultsStorage: IUserDefaultsSettings {
    
    static let shared = UserDefaultsStorage()
    
    private init() {}
    
    func changeUserInAppValue(on: Bool) {
        isUserInApp = on
    }
    
    func getUserInAppValue() -> Bool {
        return isUserInApp
    }
    
    func getAskPushValue() -> Bool {
        return wasPushAsked
    }
    
    func changePushAsked(value: Bool) {
        wasPushAsked = value
    }
    
    private var isUserInApp: Bool {
        get {
            return Defaults[\.isItTheFirstLaunch] ?? false
        }
        
        set {
            Defaults[\.isItTheFirstLaunch] = newValue
        }
    }
    
    private var wasPushAsked: Bool {
        get {
            return Defaults[\.wasPushPermissionAsked] ?? false
        }
        
        set {
            Defaults[\.wasPushPermissionAsked] = newValue
        }
    }
}

extension DefaultsKeys {
    
    private enum keys: String {
        case isUserInApp
        case wasPushPermissionAsked
    }
    
    var isItTheFirstLaunch: DefaultsKey<Bool?> {.init(keys.isUserInApp.rawValue)}
    var wasPushPermissionAsked: DefaultsKey<Bool?> {.init(keys.wasPushPermissionAsked.rawValue)}
}
