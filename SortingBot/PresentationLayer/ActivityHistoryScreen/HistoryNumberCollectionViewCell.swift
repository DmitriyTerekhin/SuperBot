//
//  HistoryNumberCollectionViewCell.swift
//  SortingBot
//
//  Created by Дмитрий Терехин on 28.12.2022.
//

import UIKit

class HistoryNumberCollectionViewCell: NumberCollectionViewCell {
    
    override func setupView() {
        addSubview(titleLabel)
        titleLabel.centerYAnchor.constraint(equalTo: titleLabel.superview!.centerYAnchor, constant: 0).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: titleLabel.superview!.centerXAnchor, constant: 0).isActive = true
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }
}
