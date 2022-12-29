//
//  ActivityListView.swift
//  SortingBot
//
//  Created by Дмитрий Терехин on 28.12.2022.
//

import UIKit

class ActivityListView: UIView {
    
    private let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Small_logo")
        return iv
    }()
    
    let tableView: UITableView = {
        let tbl = UITableView()
        tbl.register(ActivityListTableViewCell.self, forCellReuseIdentifier: ActivityListTableViewCell.reuseID)
        tbl.allowsSelection = false
        tbl.backgroundColor = .clear
        return tbl
    }()
    
    private let backButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "BackButton"), for: .normal)
        btn.tintColor = .white
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
        
        backButton.addTarget(nil, action: #selector(ActivityListViewController.backButtonTapped), for: .touchUpInside)
        
        backgroundColor = .AppCollors.backgroundBlue
        addSubview(tableView)
        addSubview(backButton)
        addSubview(logoImageView)
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backButton.centerYAnchor.constraint(equalTo: logoImageView.centerYAnchor),
            backButton.leftAnchor.constraint(equalTo: backButton.superview!.leftAnchor, constant: 56)
        ])
        
        let adaptedTopHeight = adapted(dimensionSize: 51, to: .height)
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: logoImageView.superview!.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: logoImageView.superview!.topAnchor, constant: adaptedTopHeight),
        ])
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: tableView.superview!.leftAnchor, constant: 52),
            tableView.rightAnchor.constraint(equalTo: tableView.superview!.rightAnchor, constant: -52),
            tableView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 35),
            tableView.bottomAnchor.constraint(equalTo: tableView.superview!.bottomAnchor, constant: -100)
        ])
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }

}
