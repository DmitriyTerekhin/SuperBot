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
        static let skip: String = "Skip"
        static let allowCornerRaidus: CGFloat = 5
    }
    
    private let pleaseLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Please allow us to send you\npush notifications"
        lbl.numberOfLines = 0
        lbl.setFont(fontName: .robotoBold, sizeXS: 20)
        lbl.textColor = .white
        lbl.textAlignment = .center
        return lbl
    }()
    
    private let logoIamgeView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "BlazrFire")
        return iv
    }()
    
    private let allowButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle(Constants.allow, for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .AppCollors.red
        btn.layer.cornerRadius = Constants.allowCornerRaidus
        btn.titleLabel?.setFont(fontName: .robotoBold, sizeXS: 18)
        
        if #available(iOS 15, *) {
            var config = UIButton.Configuration.plain()
            config.background.backgroundColor = UIColor.AppCollors.red
            config.background.cornerRadius = Constants.allowCornerRaidus
            config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                outgoing.font = UIFont(font: .robotoBold, size: 18)
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
        btn.titleLabel?.setFont(fontName: .robotoRegular, sizeXS: 14)
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
        backgroundColor = .AppCollors.background
        
        addSubview(logoIamgeView)
        logoIamgeView.centerXAnchor.constraint(equalTo: logoIamgeView.superview!.centerXAnchor).isActive = true
        logoIamgeView.centerYAnchor.constraint(equalTo: logoIamgeView.superview!.centerYAnchor).isActive = true
        logoIamgeView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(allowButton)
        allowButton.topAnchor.constraint(equalTo: logoIamgeView.bottomAnchor, constant: 64).isActive = true
        allowButton.centerXAnchor.constraint(equalTo: allowButton.superview!.centerXAnchor).isActive = true
        allowButton.widthAnchor.constraint(equalToConstant: 271).isActive = true
        allowButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        allowButton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(pleaseLabel)
        pleaseLabel.bottomAnchor.constraint(equalTo: logoIamgeView.topAnchor, constant: -80).isActive = true
        pleaseLabel.centerXAnchor.constraint(equalTo: pleaseLabel.superview!.centerXAnchor).isActive = true
        pleaseLabel.widthAnchor.constraint(equalToConstant: 271).isActive = true
        pleaseLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(skipButton)
        skipButton.bottomAnchor.constraint(equalTo: skipButton.superview!.safeBottomAnchor, constant: -68).isActive = true
        skipButton.centerXAnchor.constraint(equalTo: skipButton.superview!.centerXAnchor).isActive = true
        skipButton.widthAnchor.constraint(equalToConstant: 271).isActive = true
        skipButton.translatesAutoresizingMaskIntoConstraints = false
    }
    

}
