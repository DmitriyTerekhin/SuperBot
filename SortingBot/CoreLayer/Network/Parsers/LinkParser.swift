//
//  LinkParser.swift
//  Blazr
//
//  Created by Дмитрий Терехин on 17.12.2022.
//

import Foundation
import SwiftyJSON

class LinkParser: IParser {
    typealias Model = String
    
    func parse(json: JSON) -> Model? {
        return json.arrayValue.first?["link"].stringValue
    }
}
