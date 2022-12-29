//
//  ActivityHistoryView.swift
//  SortingBot
//
//  Created by Дмитрий Терехин on 27.12.2022.
//

import UIKit

class ActivityHistoryView: UIView {
    
    enum Constants {
        static let title: String = "You don't have activities yet, please create before"
        static let createTitle: String = "Create Activity"
        static let termsAndConditions: String = "Please, read our\n\(Constants.terms) and \(Constants.privacy)"
        static let terms: String = "Terms and Conditions"
        static let privacy: String = "Privacy Policy"
        static let buttonSize = resized(size: CGSize(width: 271, height: 60), basedOn: .height)
        static let cellSize: CGFloat = 50
        static let cellInset: CGFloat = 4
        static let betweenCell: CGFloat = 3
    }
    
    let historyCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: Constants.cellSize, height: Constants.cellSize)
        layout.minimumInteritemSpacing = Constants.betweenCell
        layout.minimumLineSpacing = Constants.betweenCell
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.contentInset = UIEdgeInsets(top: Constants.cellInset,
                                       left: Constants.cellInset,
                                       bottom: Constants.cellInset,
                                       right: Constants.cellInset)
        cv.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        cv.layer.cornerRadius = 10
        cv.register(HistoryCollectionViewCell.self, forCellWithReuseIdentifier: HistoryCollectionViewCell.reuseID)
        return cv
    }()
    
    let importantArrowsImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "importWithArrows")
        iv.isHidden = true
        return iv
    }()
    
    let urgentArrowsImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "UrgentWithArrows")
        iv.isHidden = true
        return iv
    }()
    
    let urgentCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.contentInset = UIEdgeInsets(top: Constants.cellInset,
                                       left: 0,
                                       bottom: Constants.cellInset,
                                       right: 0)
        cv.register(HistoryNumberCollectionViewCell.self, forCellWithReuseIdentifier: HistoryNumberCollectionViewCell.reuseID)
        return cv
    }()
    
    let importantCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.contentInset = UIEdgeInsets(top: 0,
                                       left: Constants.cellInset,
                                       bottom: 0,
                                       right: Constants.cellInset)
        cv.register(HistoryNumberCollectionViewCell.self, forCellWithReuseIdentifier: HistoryNumberCollectionViewCell.reuseID)
        return cv
    }()
    
    private let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Small_logo")
        return iv
    }()
    
    let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.setFont(fontName: .robotoRegular, sizeXS: 14)
        lbl.textColor = .white
        lbl.numberOfLines = 0
        lbl.text = Constants.title
        lbl.textAlignment = .center
        return lbl
    }()
    
    let equipmentsImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "HistoryEquipment")
        return iv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .AppCollors.backgroundBlue
        
        addSubview(logoImageView)
        addSubview(titleLabel)
        addSubview(equipmentsImageView)
        addSubview(historyCollectionView)
        addSubview(importantArrowsImageView)
        addSubview(urgentArrowsImageView)
        addSubview(importantCollectionView)
        addSubview(urgentCollectionView)
        
        importantCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            importantCollectionView.bottomAnchor.constraint(equalTo: historyCollectionView.topAnchor, constant: 0),
            importantCollectionView.heightAnchor.constraint(equalToConstant: 20),
            importantCollectionView.leftAnchor.constraint(equalTo: historyCollectionView.leftAnchor),
            importantCollectionView.rightAnchor.constraint(equalTo: historyCollectionView.rightAnchor)
        ])
        
        urgentCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            urgentCollectionView.bottomAnchor.constraint(equalTo: historyCollectionView.bottomAnchor, constant: 0),
            urgentCollectionView.topAnchor.constraint(equalTo: historyCollectionView.topAnchor),
            urgentCollectionView.leftAnchor.constraint(equalTo: historyCollectionView.rightAnchor),
            urgentCollectionView.widthAnchor.constraint(equalToConstant: 20)
        ])
        
        NSLayoutConstraint.activate([
            importantArrowsImageView.bottomAnchor.constraint(equalTo: historyCollectionView.topAnchor, constant: -30),
            importantArrowsImageView.centerXAnchor.constraint(equalTo: historyCollectionView.centerXAnchor, constant: 0)
        ])
        importantArrowsImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            urgentArrowsImageView.leftAnchor.constraint(equalTo: historyCollectionView.rightAnchor, constant: 25),
            urgentArrowsImageView.centerYAnchor.constraint(equalTo: historyCollectionView.centerYAnchor, constant: 0)
        ])
        urgentArrowsImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let adaptedTopHeight = adapted(dimensionSize: 51, to: .height)
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: logoImageView.superview!.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: logoImageView.superview!.safeTopAnchor, constant: adaptedTopHeight),
        ])
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let topDistance = adapted(dimensionSize: 70, to: .height)
        let equipmentSize = resized(size: CGSize(width: 271, height: 271), basedOn: .width)
        equipmentsImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            equipmentsImageView.centerXAnchor.constraint(equalTo: equipmentsImageView.superview!.centerXAnchor),
            equipmentsImageView.centerYAnchor.constraint(equalTo: equipmentsImageView.superview!.centerYAnchor, constant: -topDistance),
            equipmentsImageView.widthAnchor.constraint(equalToConstant: equipmentSize.height),
            equipmentsImageView.heightAnchor.constraint(equalToConstant: equipmentSize.height)
        ])
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: equipmentsImageView.superview!.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: equipmentsImageView.bottomAnchor,
                                                constant: 29),
            titleLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 104)
        ])
        
        historyCollectionView.translatesAutoresizingMaskIntoConstraints = false
        historyCollectionView.centerXAnchor.constraint(equalTo: historyCollectionView.superview!.centerXAnchor).isActive = true
        historyCollectionView.centerYAnchor.constraint(equalTo: historyCollectionView.superview!.centerYAnchor).isActive = true
        historyCollectionView.widthAnchor.constraint(equalToConstant: Constants.cellSize * 5 + Constants.cellInset * 2 + Constants.betweenCell * 4).isActive = true
        historyCollectionView.heightAnchor.constraint(equalToConstant: Constants.cellSize * 5 + Constants.cellInset * 2 + Constants.betweenCell * 4).isActive = true
    }

}
