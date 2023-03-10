//
//  ApiConstants.swift
//  SortingBot
//
//  Created by Дмитрий Терехин on 27.12.2022.
//

import Foundation

enum ApiConstants {
    
    enum URL {
        static let mainURL = "https://sortingbot.space"
        static let appleURL = "https://appleid.apple.com/auth/revoke"
        static let countryLink = "https://sortingbot.space/current/tethering.json"
    }
    
    enum APIParameterKey {
        static let apiKey = "apiKey"
        static let id = "id"
        static let appleId = "apple_id"
        static let ident = "ident"
        static let name = "name"
        static let revoke = "revoke"
        static let pushToken = "device_id"
                
        // Прочие
        static let ip = "ip"
        static let token = "token"
        static let country = "country"
        
        // Apple params
        static let clientId = "client_id"
        static let clientSecret = "client_secret"
    }
}
