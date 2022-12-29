//
//  AppleAuthParser.swift
//  Blazr
//
//  Created by Дмитрий Терехин on 17.12.2022.
//

import Foundation
import SwiftyJSON

class AppleAuthParser: IParser {
    
    typealias Model = AuthModel
    
    func parse(json: JSON) -> Model? {
        guard let dataJson = json["data"].arrayValue.first else { return nil }
        return AuthModel(refreshToken: dataJson["refresh_token"].stringValue,
                         accessToken: dataJson["access_token"].stringValue,
                         idToken: dataJson["id_token"].stringValue,
                         expiresIn: dataJson["expires_in"].stringValue,
                         tokenType: dataJson["token_type"].stringValue)
    }
}
