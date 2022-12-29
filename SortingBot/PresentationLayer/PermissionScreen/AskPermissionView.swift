//
//  AskPermissionView.swift
//  SortingBot
//
//  Created by Дмитрий Терехин on 26.12.2022.
//

import UIKit

class AskPermissionView: UIView {
    
    enum Constants {
        static let attention: String = "Attention!"
        static let allow: String = "Allow"
        static let skip: String = "Next time"
        static let allowButtonHeight: CGFloat = 60
    }
    
    private let titlelabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "We'd like to send you updates and alerts through push notifications.\n\nThis will allow us to keep you informed about important news and events, as well as special offers and promotions."
        lbl.numberOfLines = 0
        lbl.setFont(fontName: .robotoRegular, sizeXS: 14)
        lbl.textColor = .white
        lbl.textAlignment = .center
        return lbl
    }()
    
    private let logoIamgeView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Small_logo")
        return iv
    }()
    
    private let allowButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle(Constants.allow, for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .AppCollors.red
        btn.layer.cornerRadius = Constants.allowButtonHeight/2
        btn.titleLabel?.setFont(fontName: .robotoBold, sizeXS: 20)
        
        if #available(iOS 15, *) {
            var config = UIButton.Configuration.plain()
            config.background.backgroundColor = UIColor.AppCollors.red
            config.background.cornerRadius = Constants.allowButtonHeight/2
            config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                outgoing.font = UIFont(font: .robotoBold, size: 20)
                return outgoing
            }
            btn.configuration = config
        }
        btn.addTarget(nil, action: #selector(AskPermissionsViewController.allowTapped), for: .touchUpInside)
        return btn
    }()
    
    private let skipButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle(Constants.skip, for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.setFont(fontName: .robotoRegular, sizeXS: 12)
        btn.addTarget(nil, action: #selector(AskPermissionsViewController.skipTapped), for: .touchUpInside)
        btn.titleLabel?.underline()
        return btn
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .AppCollors.backgroundBlue
        
        addSubview(logoIamgeView)
        addSubview(titlelabel)
        addSubview(allowButton)
        addSubview(titlelabel)
        addSubview(skipButton)
        
        logoIamgeView.centerXAnchor.constraint(equalTo: logoIamgeView.superview!.centerXAnchor).isActive = true
        logoIamgeView.bottomAnchor.constraint(equalTo: titlelabel.topAnchor, constant: -52).isActive = true
        logoIamgeView.translatesAutoresizingMaskIntoConstraints = false
        
        allowButton.topAnchor.constraint(equalTo: titlelabel.bottomAnchor, constant: 93).isActive = true
        allowButton.centerXAnchor.constraint(equalTo: allowButton.superview!.centerXAnchor).isActive = true
        allowButton.widthAnchor.constraint(equalToConstant: 271).isActive = true
        allowButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        allowButton.translatesAutoresizingMaskIntoConstraints = false
        
        titlelabel.centerXAnchor.constraint(equalTo: titlelabel.superview!.centerXAnchor).isActive = true
        titlelabel.centerYAnchor.constraint(equalTo: titlelabel.superview!.centerYAnchor).isActive = true
        titlelabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 104).isActive = true
        titlelabel.translatesAutoresizingMaskIntoConstraints = false
        
        skipButton.bottomAnchor.constraint(equalTo: skipButton.superview!.safeBottomAnchor, constant: -76).isActive = true
        skipButton.centerXAnchor.constraint(equalTo: skipButton.superview!.centerXAnchor).isActive = true
        skipButton.widthAnchor.constraint(equalToConstant: 271).isActive = true
        skipButton.translatesAutoresizingMaskIntoConstraints = false
    }
    

}
