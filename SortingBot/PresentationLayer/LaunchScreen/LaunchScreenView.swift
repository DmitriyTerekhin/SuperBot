//
//  LaunchScreenView.swift
//  SortingBot
//
//  Created by Дмитрий Терехин on 27.12.2022.
//

import UIKit

class LaunchScreenView: UIView {

    private let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Big_logo")
        return iv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .AppCollors.backgroundBlue
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(logoImageView)
        logoImageView.centerYAnchor.constraint(equalTo: logoImageView.superview!.centerYAnchor, constant: 0).isActive = true
        logoImageView.centerXAnchor.constraint(equalTo: logoImageView.superview!.centerXAnchor).isActive = true
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
    }

}
