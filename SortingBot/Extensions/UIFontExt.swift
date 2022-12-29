//
//  UIFontExt.swift
//  Blazr
//
//  Created by Дмитрий Терехин on 07.12.2022.
//
import UIKit
import ScreenType

extension UIFont {
    
    // For XS
    convenience init(font: Font, size: CGFloat) {
        self.init(name: font.rawValue, size: size.adaptedFontSize)!
    }
    
    enum Font: String {
        case robotoBlack = "Roboto-Black"
        case robotoRegular = "Roboto-Regular"
        case robotoThin = "Roboto-Thin"
        case robotoBold = "Roboto-Bold"
        case RobotoMedium = "Roboto-Medium"
    }
    
    func printAllFonts() {
        let fontFamilyNames = UIFont.familyNames

        for familyName in fontFamilyNames {
            print("------------------------------")
            print("Font Family Name = [\(familyName)]")

            let names = UIFont.fontNames(forFamilyName: familyName)
            print("Font Names = [\(names)]")
        }

    }
    
    static func getFontSizeForDifferentDevice(sizeXS: CGFloat) -> CGFloat {
        switch UIScreen.current {
        case .iPhone3_5:
            return sizeXS - 3
        case .iPhone4_0:
            return sizeXS - 2
        case .iPhone4_7:
            return sizeXS - 1
        case .iPhone5_5:
            return sizeXS - 1
        case .iPhone5_8: //XS
            return sizeXS
        case .iPhone6_1:
            return sizeXS
        case .iPhone6_5:
            return sizeXS + 1
        case .iPad9_7:
            return sizeXS + 3
        case .iPad10_5:
            return sizeXS + 3
        case .iPad12_9:
            return sizeXS + 3
        case .unknown:
            return sizeXS + 1
        }
    }
}
