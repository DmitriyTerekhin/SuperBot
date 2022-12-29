//
//  CountryParser.swift
//  Blazr
//
//  Created by Дмитрий Терехин on 17.12.2022.
//

import Foundation
import SwiftyJSON

class CountryParser: IParser {
    typealias Model = (AppWayByCountry)
    
    func parse(json: JSON) -> Model? {
        guard let tab = Int(json["data"]["tabs"].stringValue) else { return nil}
        return AppWayByCountry(tab: tab)
    }
}
