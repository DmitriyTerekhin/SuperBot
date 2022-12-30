//
//  CheckBoxButtonView.swift
//  SuperBest
//
//  Created by Дмитрий Терехин on 31.10.2022.
//

import UIKit
import ActiveLabel

class CheckBoxButtonView: UIView {
    
    // Public
    var turnOn: Bool = true
    
    let checkBoxButton: UIButton = {
        let btn = UIButton()
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.AppCollors.red.cgColor
        btn.layer.cornerRadius = 3
        btn.backgroundColor = UIColor.AppCollors.red
        return btn
    }()
    
    let textView: UITextView = {
        let txt = UITextView()
        txt.textColor = .white
        txt.textAlignment = .left
        txt.isUserInteractionEnabled = true
        txt.textContainer.maximumNumberOfLines = 2
        txt.isScrollEnabled = false
        txt.isEditable = false
        txt.showsHorizontalScrollIndicator = false
        txt.backgroundColor = .clear
        return txt
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addText(text: NSString, wordsInText: String, siteToGo: String) {
        textView.font = UIFont(font: .robotoRegular, size: 10)
        let attributedString = textView.addHyperLinksToText(originalText: text as String,
                                                            hyperLinks: [ wordsInText: siteToGo],
                                                            textColor: UIColor.white,
                                                            font: UIFont(font: .robotoRegular, size: 10))
        let linkAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: UIColor.white]
        textView.linkTextAttributes = linkAttributes
        textView.isUserInteractionEnabled = true
        let underlineAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue]
        let range = text.range(of: wordsInText, options: .caseInsensitive)
        attributedString.addAttributes(underlineAttributes, range: range)
        textView.attributedText = attributedString
        textView.textAlignment = .left
    }
    
    @objc
    func checkBoxButtonTapped() {
        turnOn.toggle()
        if turnOn {
            checkBoxButton.backgroundColor = UIColor.red
        } else {
            checkBoxButton.backgroundColor = UIColor.clear
        }
    }
    
    private func setupView() {
        addSubview(checkBoxButton)
        addSubview(textView)
        
        checkBoxButton.leftAnchor.constraint(equalTo: checkBoxButton.superview!.leftAnchor, constant: 0).isActive = true
        checkBoxButton.widthAnchor.constraint(equalToConstant: 8).isActive = true
        checkBoxButton.heightAnchor.constraint(equalToConstant: 8).isActive = true
        checkBoxButton.centerYAnchor.constraint(equalTo: textView.centerYAnchor, constant: 0).isActive = true
        checkBoxButton.translatesAutoresizingMaskIntoConstraints = false
                
        textView.leftAnchor.constraint(equalTo: checkBoxButton.rightAnchor, constant: 5).isActive = true
        textView.rightAnchor.constraint(equalTo: textView.superview!.rightAnchor, constant: 0).isActive = true
        textView.centerYAnchor.constraint(equalTo: textView.superview!.centerYAnchor).isActive = true
        textView.translatesAutoresizingMaskIntoConstraints = false
    }
}

private extension UITextView {
    func addHyperLinksToText(originalText: String,
                             hyperLinks: [String: String],
                             textColor: UIColor,
                             font: UIFont) -> NSMutableAttributedString {
        let style = NSMutableParagraphStyle()
        style.alignment = .left
        let attributedOriginalText = NSMutableAttributedString(string: originalText)
        for (hyperLink, urlString) in hyperLinks {
            _ = attributedOriginalText.mutableString.range(of: hyperLink)
            let fullRange = NSRange(location: 0, length: attributedOriginalText.length)
            let linkRange = attributedOriginalText.mutableString.range(of: hyperLink)
            attributedOriginalText.addAttribute(NSAttributedString.Key.link, value: urlString, range: linkRange)
            attributedOriginalText.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: fullRange)
            attributedOriginalText.addAttribute(NSAttributedString.Key.font, value: font, range: fullRange)
            attributedOriginalText.addAttributes([NSAttributedString.Key.foregroundColor: textColor], range: fullRange)
        }
        return attributedOriginalText
    }
}
