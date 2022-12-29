//
//  HistoryCollectionViewCell.swift
//  SortingBot
//
//  Created by Дмитрий Терехин on 28.12.2022.
//

import UIKit

class HistoryCollectionViewCell: UICollectionViewCell, ReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 10
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepare(eventExist: Bool) {
        contentView.backgroundColor = eventExist ? UIColor.AppCollors.red : UIColor.white.withAlphaComponent(0.5)
    }
}
