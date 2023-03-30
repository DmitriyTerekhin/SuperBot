//
//  SettingsTableViewCell.swift
//  SortingBot
//
//  Created by Дмитрий Терехин on 27.12.2022.
//

import UIKit

class SettingsTableViewCell: UITableViewCell, ReusableView {

    let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.textAlignment = .center
        lbl.setFont(fontName: .KanitRegular, sizeXS: 20)
        return lbl
    }()
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        UIView.animate(withDuration: 0.3,
                       animations: {
            self.titleLabel.textColor = .white.withAlphaComponent(0.5)
        },
                       completion:{ _ in
            UIView.animate(withDuration: 0.3,
                           animations: {
                self.titleLabel.textColor = .white.withAlphaComponent(1)
            })
        })
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .clear
        contentView.addSubview(titleLabel)
        titleLabel.centerYAnchor.constraint(equalTo: titleLabel.superview!.centerYAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: titleLabel.superview!.centerXAnchor, constant: 0).isActive = true
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }

}
