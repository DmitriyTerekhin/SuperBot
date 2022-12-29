//
//  UILabelExt.swift
//  Blazr
//
//  Created by Дмитрий Терехин on 08.12.2022.
//

import UIKit
import ScreenType

extension UILabel {
    func setFont(fontName: UIFont.Font, sizeXS: CGFloat) {
        let fontSize = UIFont.getFontSizeForDifferentDevice(sizeXS: sizeXS)
        font = UIFont(name: fontName.rawValue, size: fontSize)
    }
    
}

extension UILabel {
    func addCharacterSpacing(kernValue: Double = 1.15) {
        if let labelText = text, labelText.count > 0 {
            let attributedString = NSMutableAttributedString(string: labelText)
            attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(1.0), range: NSRange(location: 0, length: attributedString.length))
            attributedText = attributedString
        }
    }
    
    func estimatedLabelHeight(text: String, width: CGFloat) -> CGFloat {
        let size = CGSize(width: width, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let attributes = [NSAttributedString.Key.font: font]
        let rectangleHeight = String(text).boundingRect(with: size, options: options, attributes: attributes as [NSAttributedString.Key : Any], context: nil).height
        return rectangleHeight
    }
}

extension UILabel {
    func highlight(text: String?, font: UIFont? = nil, color: UIColor? = nil) {
        guard let fullText = self.text, let target = text else {
            return
        }

        let attribText = NSMutableAttributedString(string: fullText)
        let range: NSRange = attribText.mutableString.range(of: target, options: .caseInsensitive)
        
        var attributes: [NSAttributedString.Key: Any] = [:]
        if let font = font {
            attributes[.font] = font
        }
        if let color = color {
            attributes[.foregroundColor] = color
        }
        attribText.addAttributes(attributes, range: range)
        self.attributedText = attribText
    }
}

extension UILabel {
    func underline() {
        if let textString = self.text {
          let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle,
                                          value: NSUnderlineStyle.single.rawValue,
                                          range: NSRange(location: 0, length: attributedString.length))
          attributedText = attributedString
        }
    }
    
    func adjustFontSizeToWidth() {
        
        enum Constants {
            static let fontDecrement: CGFloat = 1.0
            static let minimumFontSize: CGFloat = 6.0
        }
        
        var characterSet = CharacterSet.whitespacesAndNewlines
        characterSet.insert(charactersIn: "-")
        let words = text?.components(separatedBy: characterSet)
        
        var largestWord = ""
        var largestWordWidth: CGFloat = 0
        
        words?.forEach { word in
            let wordSize = (word as NSString).size(withAttributes: [NSAttributedString.Key.font: font])
            let wordWidth = wordSize.width
            
            if wordWidth > largestWordWidth {
                largestWordWidth = wordWidth
                largestWord = word
            }
        }
        
        while largestWordWidth > bounds.width && font.pointSize > Constants.minimumFontSize {
            font = font.withSize(font.pointSize - Constants.fontDecrement)
            let largestWordSize = (largestWord as NSString).size(withAttributes: [NSAttributedString.Key.font: font])
            largestWordWidth = largestWordSize.width
        }
    }
}
