//
//  ActivityListTableViewCell.swift
//  SortingBot
//
//  Created by Дмитрий Терехин on 28.12.2022.
//

import UIKit

protocol ActivityListTableViewCellDelegate: AnyObject {
    func doneButtonTapped(activity: ActivityModel)
}

class ActivityListTableViewCell: UITableViewCell, ReusableView {
    
    private enum Constants {
        static let whiteBackgroundHeight: CGFloat = 60
        static let imageSize: CGFloat = 40
    }
    
    private let doneButtonView: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "TickActivity"), for: .normal)
        return btn
    }()
    
    private let colorView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = Constants.whiteBackgroundHeight/2
        return view
    }()
    
    private let activityImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "FootbalImage")
        iv.clipsToBounds = true
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .AppCollors.backgroundBlue
        lbl.numberOfLines = 0
        lbl.textAlignment = .left
        lbl.text = "Visit match of Liverpool and ManUnited"
        lbl.setFont(fontName: .robotoRegular, sizeXS: 10)
        return lbl
    }()
    
    weak var delegate: ActivityListTableViewCellDelegate?
    private var model: ActivityModel?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    func doneTapped() {
        guard let model = model else { return }
        delegate?.doneButtonTapped(activity: model)
    }
    
    func setup(with model: ActivityModel) {
        self.model = model
        if let image = model.image {
            activityImageView.image = UIImage(data: image)
        }
        titleLabel.text = model.name
    }
    
    private func setupView() {
        doneButtonView.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
        backgroundColor = .clear
        activityImageView.layer.cornerRadius = Constants.imageSize/2
        
        contentView.addSubview(colorView)
        colorView.addSubview(activityImageView)
        colorView.addSubview(doneButtonView)
        colorView.addSubview(titleLabel)
        
        colorView.translatesAutoresizingMaskIntoConstraints = false
        colorView.leftAnchor.constraint(equalTo: colorView.superview!.leftAnchor).isActive = true
        colorView.rightAnchor.constraint(equalTo: colorView.superview!.rightAnchor).isActive = true
        colorView.topAnchor.constraint(equalTo: colorView.superview!.topAnchor).isActive = true
        colorView.heightAnchor.constraint(equalToConstant: Constants.whiteBackgroundHeight).isActive = true
        colorView.bottomAnchor.constraint(equalTo: colorView.superview!.bottomAnchor, constant: -10).isActive = true
        
        activityImageView.translatesAutoresizingMaskIntoConstraints = false
        activityImageView.leftAnchor.constraint(equalTo: activityImageView.superview!.leftAnchor,
                                                constant: 13).isActive = true
        activityImageView.widthAnchor.constraint(equalToConstant: Constants.imageSize).isActive = true
        activityImageView.heightAnchor.constraint(equalToConstant: Constants.imageSize).isActive = true
        activityImageView.centerYAnchor.constraint(equalTo: activityImageView.superview!.centerYAnchor).isActive = true
        
        doneButtonView.translatesAutoresizingMaskIntoConstraints = false
        doneButtonView.rightAnchor.constraint(equalTo: doneButtonView.superview!.rightAnchor,
                                                       constant: -13).isActive = true
        doneButtonView.widthAnchor.constraint(equalToConstant: Constants.imageSize).isActive = true
        doneButtonView.heightAnchor.constraint(equalToConstant: Constants.imageSize).isActive = true
        doneButtonView.centerYAnchor.constraint(equalTo: doneButtonView.superview!.centerYAnchor).isActive = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leftAnchor.constraint(equalTo: activityImageView.rightAnchor, constant: 13).isActive = true
        titleLabel.topAnchor.constraint(greaterThanOrEqualTo: titleLabel.superview!.topAnchor, constant: 5).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: titleLabel.superview!.centerYAnchor).isActive = true
        titleLabel.rightAnchor.constraint(lessThanOrEqualTo: doneButtonView.leftAnchor, constant: -13).isActive = true
        titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: titleLabel.superview!.bottomAnchor, constant: -5).isActive = true
    }
    
}
