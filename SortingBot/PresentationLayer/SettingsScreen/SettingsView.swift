//
//  SettingsView.swift
//  SortingBot
//
//  Created by Дмитрий Терехин on 27.12.2022.
//

import UIKit

class SettingsView: UIView {
    
    private let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Small_logo")
        return iv
    }()
    
    let tableView: UITableView = {
        let tbl = UITableView()
        tbl.showsVerticalScrollIndicator = false
        tbl.rowHeight = UIScreen.current.rawValue > 2 ? CGFloat(44).dp : CGFloat(34).dp
        tbl.separatorStyle = .none
        tbl.backgroundColor = .clear
        tbl.isScrollEnabled = false
        tbl.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.reuseID)
        return tbl
    }()
    
    var tableHeightAnchor = NSLayoutConstraint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .AppCollors.backgroundBlack
        addSubview(logoImageView)
        let sizeLogo = resized(size: CGSize(width: 67, height: 86), basedOn: .height)
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: logoImageView.superview!.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: logoImageView.superview!.safeTopAnchor,
                                               constant: 46),
            logoImageView.widthAnchor.constraint(equalToConstant: sizeLogo.width),
            logoImageView.heightAnchor.constraint(equalToConstant: sizeLogo.height)
        ])
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.centerXAnchor.constraint(equalTo: tableView.superview!.centerXAnchor, constant: 0),
            tableView.centerYAnchor.constraint(equalTo: tableView.superview!.centerYAnchor, constant: 0),
            tableView.rightAnchor.constraint(equalTo: tableView.superview!.rightAnchor),
            tableView.leftAnchor.constraint(equalTo: tableView.superview!.leftAnchor)
        ])
        tableHeightAnchor = tableView.heightAnchor.constraint(equalToConstant: 400)
        tableHeightAnchor.isActive = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }

}
