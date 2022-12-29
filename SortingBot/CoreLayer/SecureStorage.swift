//
//  SecureStorage.swift
//  SortingBot
//
//  Created by Дмитрий Терехин on 26.12.2022.
//

import Foundation
import KeychainSwift

protocol ISecureStorage {
    func getToken() -> String?
    func premiumIsActive() -> Bool
    func savePremium()
    func saveAppleAccessToken(token: String)
    func saveAppleToken(token: String)
    func saveAppleRefreshToken(token: String)
    func getAppleToken() -> String?
    func saveToken(token: String, completionHandler: FinishedCompletionHandler)
    func savePushToken(token: String)
    func deleteAllInfo(completionBlock: FinishedCompletionHandler)
}

class SecureStorage: ISecureStorage {
    
    private let keychain = KeychainSwift()
    static let shared = SecureStorage()
    
    private init () {}
    
    private enum Constants: String {
        case token
        case premium
        case appleAccessToken
        case appleRefreshToken
        case appleToken
        case pushToken
        
        var title: String {
            return self.rawValue
        }
    }
    
    func saveToken(token: String, completionHandler: FinishedCompletionHandler) {
        keychain.set(token, forKey: Constants.token.title)
        completionHandler(true)
    }
    
    func getToken() -> String? {
        return keychain.get(Constants.token.title)
    }
    
    func deleteAllInfo(completionBlock: FinishedCompletionHandler) {
        completionBlock(keychain.clear())
    }
    
    func savePremium() {
        keychain.set(true, forKey: Constants.premium.title)
    }
    
    func premiumIsActive() -> Bool {
        return keychain.getBool(Constants.premium.title) ?? false
    }
    
    func saveAppleAccessToken(token: String) {
        keychain.set(token, forKey: Constants.appleAccessToken.title)
    }
    func saveAppleRefreshToken(token: String) {
        keychain.set(token, forKey: Constants.appleRefreshToken.title)
    }
    func saveAppleToken(token: String) {
        keychain.set(token, forKey: Constants.appleToken.title)
    }
    func getAppleToken() -> String? {
        keychain.get(Constants.appleToken.title)
    }
    func savePushToken(token: String) {
        keychain.set(token, forKey: Constants.pushToken.title)
    }
}
