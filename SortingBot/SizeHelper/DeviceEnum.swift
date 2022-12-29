//
//  DeviceEnum.swift
//  Blazr
//
//  Created by Дмитрий Терехин on 10.12.2022.
//

import UIKit


enum Device {
    case iphoneSE
    case iphone8
    case iphone8Plus // XS
    case iphone11Pro
    case iphone11ProMax
    
    static let baseScreenSize: Device = .iphone8Plus

}

extension Device: RawRepresentable {
    typealias RawValue = CGSize
    
    init?(rawValue: CGSize) {
        switch rawValue {
        case CGSize(width: 320, height: 568):
            self = .iphoneSE
        case CGSize(width: 375, height: 667):
            self = .iphone8
        case CGSize(width: 414, height: 736):
            self = .iphone8Plus
        case CGSize(width: 375, height: 812):
            self = .iphone11Pro
        case CGSize(width: 414, height: 896):
            self = .iphone11ProMax
        default:
            return nil
        }
    }
    
    var rawValue: CGSize {
        switch self {
        case .iphoneSE:
            return CGSize(width: 320, height: 568)
        case .iphone8:
            return CGSize(width: 375, height: 667)
        case .iphone8Plus:
            return CGSize(width: 414, height: 736)
        case .iphone11Pro:
            return CGSize(width: 375, height: 812)
        case .iphone11ProMax:
            return CGSize(width: 414, height: 896)
        }
    }
}
