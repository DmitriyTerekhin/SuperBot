//
//  UIColorExt.swift
//  Blazr
//
//  Created by Дмитрий Терехин on 07.12.2022.
//

import UIKit

//MARK: - Dark Theme
extension UIColor {
    static func color(light: UIColor, dark: UIColor) -> UIColor {
        if #available(iOS 13, *) {
            return UIColor.init { traitCollection in
                return traitCollection.userInterfaceStyle == .dark ? dark : light
            }
        } else {
            return light
        }
    }
}

extension UIColor {
    
    static func getColor(_ red: Float, _ green: Float, _ blue: Float) -> UIColor {
        return UIColor(red: CGFloat(red / 255), green: CGFloat(green / 255), blue: CGFloat(blue / 255), alpha: 100)
    }
    
    convenience init(hex: String, alpha: CGFloat = 1.0) {
      var cString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
      
      if cString.hasPrefix("#") { cString.removeFirst() }
      
      if cString.count != 6 {
          self.init(hex: "ff0000") // return red color for wrong hex input
          return
      }
      
      var rgbValue: UInt64 = 0
      Scanner(string: cString).scanHexInt64(&rgbValue)
      
      self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                alpha: alpha)
    }
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex: Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
    enum AppCollors {
        static let red = UIColor(netHex: 0xEA1D25)
        static let backgroundBlue = UIColor(netHex: 0x0988D1)
    }
}
