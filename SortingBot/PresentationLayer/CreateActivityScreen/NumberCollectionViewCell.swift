//
//  NumberCollectionViewCell.swift
//  SortingBot
//
//  Created by Дмитрий Терехин on 28.12.2022.
//

import UIKit

class NumberCollectionViewCell: UICollectionViewCell, ReusableView {
    
    let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.setFont(fontName: .robotoBold, sizeXS: 14)
        lbl.textColor = UIColor.white.withAlphaComponent(0.5)
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepare(with text: String, isActive: Bool = false) {
        let alpha: CGFloat = isActive ? 1 : 0.5
        titleLabel.textColor = UIColor.white.withAlphaComponent(alpha)
        titleLabel.text = text
    }
    
    func setupView() {
        addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: titleLabel.superview!.topAnchor, constant: 0).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: titleLabel.superview!.leftAnchor, constant: 0).isActive = true
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
}
