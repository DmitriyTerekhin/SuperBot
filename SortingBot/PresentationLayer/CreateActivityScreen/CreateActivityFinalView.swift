//
//  CreateActivityFinalView.swift
//  SortingBot
//
//  Created by Дмитрий Терехин on 28.12.2022.
//

import UIKit

class CreateActivityFinalView: UIView {
    
    private enum Constants {
        static let imageSize = resized(size: CGSize(width: 260, height: 260), basedOn: .width)
    }

    let activityImageView = UIImageView()
    private let pointImageView = UIImageView()
    private let nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        lbl.setFont(fontName: .KanitBold, sizeXS: 16)
        lbl.text = "Visit match of Liverpool and ManUnited"
        return lbl
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeSumImage(currentSum: Int) {
        pointImageView.image = UIImage(named: "x\(currentSum)")
    }
    
    func setTitle(text: String?) {
        nameLabel.text = text
    }
    
    private func setupView() {
        pointImageView.image = UIImage(named: "x8")
        activityImageView.image = UIImage(named: "FootbalImage")
        activityImageView.layer.cornerRadius = Constants.imageSize.height/2
        activityImageView.clipsToBounds = true
        addSubview(activityImageView)
        addSubview(pointImageView)
        addSubview(nameLabel)
        
        activityImageView.layer.cornerRadius = 10
        activityImageView.translatesAutoresizingMaskIntoConstraints = false
        activityImageView.widthAnchor.constraint(equalToConstant: Constants.imageSize.height).isActive = true
        activityImageView.heightAnchor.constraint(equalToConstant: Constants.imageSize.height).isActive = true
        activityImageView.centerXAnchor.constraint(equalTo: activityImageView.superview!.centerXAnchor).isActive = true
        activityImageView.topAnchor.constraint(equalTo: activityImageView.superview!.topAnchor, constant: 10).isActive = true
        
        let size = resized(size: CGSize(width: 271, height: 157), basedOn: .height)
        pointImageView.widthAnchor.constraint(equalToConstant: size.width).isActive = true
        pointImageView.heightAnchor.constraint(equalToConstant: size.height).isActive = true
        pointImageView.centerXAnchor.constraint(equalTo: activityImageView.rightAnchor,
                                                constant: -Constants.imageSize.height/7).isActive = true
        pointImageView.centerYAnchor.constraint(equalTo: activityImageView.topAnchor,
                                                constant: Constants.imageSize.height/7).isActive = true
        pointImageView.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.topAnchor.constraint(equalTo: activityImageView.bottomAnchor, constant: 17).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: nameLabel.superview!.leftAnchor, constant: 52).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: nameLabel.superview!.rightAnchor, constant: -52).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: nameLabel.superview!.bottomAnchor, constant: -5).isActive = true
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
    }

}
