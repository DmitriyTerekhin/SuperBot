//
//  AppleRevokeTokenParser.swift
//  Blazr
//
//  Created by Дмитрий Терехин on 17.12.2022.
//

import Foundation
import SwiftyJSON

class AppleRevokeTokenParser: IParser {
        
    typealias Model = Bool
    
    func parse(json: JSON) -> Model? {
        return true
    }
}
