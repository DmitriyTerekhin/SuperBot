//
//  EnterView.swift
//  SortingBot
//
//  Created by Дмитрий Терехин on 26.12.2022.
//

import UIKit

class EnterView: UIView {
    
    private enum Constants {
        static let title: String = "To get started, please create an account.\n\nThis will allow you to access all of our features and personalize your experience.\n\nDon't worry, we'll never share your information with third parties. If you have any questions or need assistance, please don't hesitate to contact us."
        static let appleSignIn: String = "Sign In with Apple"
        static let termsAndConditions: String = "Please, read our\n\(Constants.terms) and \(Constants.privacy)"
        static let terms: String = "Terms and Conditions"
        static let privacy: String = "Privacy Policy"
        static let signInButtonSize = resized(size: CGSize(width: 271, height: 60), basedOn: .height)
    }
    
    private let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Small_logo")
        return iv
    }()
    
    private let termsAndPolicyTextView: UITextView = {
        let txtV = UITextView()
        txtV.textColor = .white
        txtV.text = Constants.termsAndConditions
        txtV.backgroundColor = .clear
        return txtV
    }()
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        lbl.setFont(fontName: .robotoRegular, sizeXS: 14)
        lbl.textColor = .white
        lbl.text = Constants.title
        return lbl
    }()
    
    private let signInButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle(Constants.appleSignIn, for: .normal)
        btn.setImage(UIImage(named: "AppleIcon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = .white
        btn.titleLabel!.setFont(fontName: .robotoBold, sizeXS: 20)
        if #available(iOS 15, *) {
            var config = UIButton.Configuration.plain()
            config.imagePadding = 10
            config.background.backgroundColor = UIColor.AppCollors.red
            config.background.cornerRadius = Constants.signInButtonSize.height/2
            config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                outgoing.font = UIFont(font: .robotoBold, size: 20)
                return outgoing
            }
            btn.configuration = config
        } else {
            btn.imageEdgeInsets.right = 15
            btn.imageEdgeInsets.bottom = 3
            btn.backgroundColor = .AppCollors.red
        }
        btn.layer.cornerRadius = Constants.signInButtonSize.height/2
        btn.setTitleColor(.white, for: .normal)
        return btn
    }()
    
    var signInHandler: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareAttributesForTextView()
        setupView()
        signInButton.addTarget(self, action: #selector(signInTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func signInTapped() {
        signInHandler?()
    }
    
    private func setupView() {
        backgroundColor = .AppCollors.backgroundBlue
        
        let leftRightDistance = adapted(dimensionSize: 52, to: .height)
        
        addSubview(titleLabel)
        titleLabel.centerXAnchor.constraint(equalTo: titleLabel.superview!.centerXAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: titleLabel.superview!.leftAnchor, constant: leftRightDistance).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: titleLabel.superview!.rightAnchor, constant: -leftRightDistance).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: titleLabel.superview!.centerYAnchor, constant: 0).isActive = true
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(logoImageView)
        logoImageView.centerXAnchor.constraint(equalTo: logoImageView.superview!.centerXAnchor).isActive = true
        logoImageView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -56).isActive = true
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(termsAndPolicyTextView)
        let termsBottom = adapted(dimensionSize: 68, to: .height)
        termsAndPolicyTextView.centerXAnchor.constraint(equalTo: termsAndPolicyTextView.superview!.centerXAnchor, constant: 0).isActive = true
        termsAndPolicyTextView.bottomAnchor.constraint(equalTo: termsAndPolicyTextView.superview!.bottomAnchor, constant: -termsBottom).isActive = true
        termsAndPolicyTextView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        termsAndPolicyTextView.leftAnchor.constraint(equalTo: termsAndPolicyTextView.superview!.leftAnchor, constant: leftRightDistance).isActive = true
        termsAndPolicyTextView.rightAnchor.constraint(equalTo: termsAndPolicyTextView.superview!.rightAnchor, constant: -leftRightDistance).isActive = true
        termsAndPolicyTextView.translatesAutoresizingMaskIntoConstraints = false
        
        let bottomDistance = adapted(dimensionSize: 175, to: .height)
        addSubview(signInButton)
        signInButton.centerXAnchor.constraint(equalTo: signInButton.superview!.centerXAnchor).isActive = true
        signInButton.heightAnchor.constraint(equalToConstant: Constants.signInButtonSize.height).isActive = true
        signInButton.bottomAnchor.constraint(equalTo: signInButton.superview!.bottomAnchor, constant: -bottomDistance).isActive = true
        signInButton.widthAnchor.constraint(equalToConstant: Constants.signInButtonSize.width).isActive = true
        signInButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func prepareAttributesForTextView() {
        let text = (termsAndPolicyTextView.text ?? "") as NSString
        termsAndPolicyTextView.font = UIFont(font: .robotoRegular, size: 12)
        let attributedString = termsAndPolicyTextView.addHyperLinksToText(
            originalText: text as String,
            hyperLinks: [
                Constants.privacy: "https://get-nacional.space/privacy.html",
                Constants.terms: "https://get-nacional.space/terms.html"
            ],
            font:  UIFont(font: .robotoRegular, size: 12)
        )
        let linkAttributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        termsAndPolicyTextView.linkTextAttributes = linkAttributes
        termsAndPolicyTextView.textColor = .white
        termsAndPolicyTextView.textAlignment = .center
        termsAndPolicyTextView.isUserInteractionEnabled = true
        termsAndPolicyTextView.isEditable = false
        termsAndPolicyTextView.attributedText = attributedString
    }
    
}

private extension UITextView {
    func addHyperLinksToText(originalText: String, hyperLinks: [String: String], font: UIFont, textAlignment: NSTextAlignment = .center) -> NSMutableAttributedString {
        let style = NSMutableParagraphStyle()
        style.alignment = textAlignment
        let attributedOriginalText = NSMutableAttributedString(string: originalText)
        let fullRange = NSRange(location: 0, length: attributedOriginalText.length)
        for (hyperLink, urlString) in hyperLinks {
            let linkRange = attributedOriginalText.mutableString.range(of: hyperLink)
            attributedOriginalText.addAttribute(NSAttributedString.Key.link, value: urlString, range: linkRange)
            attributedOriginalText.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: fullRange)
            attributedOriginalText.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: linkRange)
            attributedOriginalText.addAttribute(NSAttributedString.Key.font, value: font, range: fullRange)
        }
        attributedOriginalText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: fullRange)
        return attributedOriginalText
    }
}
