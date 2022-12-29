//
//  SetPremiumParser.swift
//  Blazr
//
//  Created by Дмитрий Терехин on 17.12.2022.
//

import Foundation
import SwiftyJSON

class SetPremiumParser: IParser {
    
    typealias Model = (Bool, String)
    
    func parse(json: JSON) -> Model? {
        return (json["data"]["premium"].boolValue, json["message"].stringValue)
    }

}
