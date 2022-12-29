//
//  LaunchScreenModel.swift
//  SortingBot
//
//  Created by Дмитрий Терехин on 27.12.2022.
//

import Foundation

struct LaunchModel {
    let countryCode: String
    let appWay: AppWayByCountry
}

enum AppWayByCountry {
    case toApp
    case web
    
    init(tab: Int) {
        switch tab {
        case 1:
            self = .toApp
        case 2:
            self = .web
        default:
            self = .web
        }
    }
}
