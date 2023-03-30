//
//  CreateActivityPointsView.swift
//  SortingBot
//
//  Created by Дмитрий Терехин on 27.12.2022.
//

import UIKit

class CreateActivityPointsView: UIView {
    
    private enum Constants {
        static let imageSize = resized(size: CGSize(width: 271, height: 271), basedOn: .width)
        static let urgentText = "How urgent is it?"
        static let importantText = "How important is it?"
    }

    private let pointImageView = UIImageView()
    private let urgentLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.white
        lbl.text = Constants.urgentText
        lbl.setFont(fontName: .KanitBold, sizeXS: 16)
        return lbl
    }()
    
    let urgentCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.register(NumberCollectionViewCell.self, forCellWithReuseIdentifier: NumberCollectionViewCell.reuseID)
        return cv
    }()
    
    let importantCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.register(NumberCollectionViewCell.self, forCellWithReuseIdentifier: NumberCollectionViewCell.reuseID)
        return cv
    }()
    
    private let importantLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.white
        lbl.text = Constants.importantText
        lbl.setFont(fontName: .KanitBold, sizeXS: 16)
        return lbl
    }()
    
    private let urgentSlider: CustomSlider = {
        let slider = CustomSlider()
        slider.tag = 1
        slider.addTarget(nil, action: #selector(CreateActivityViewController.sliderValueChanged(_:)), for: .valueChanged)
        slider.minimumTrackTintColor = .AppCollors.red
        slider.maximumTrackTintColor = .white.withAlphaComponent(0.5)
        slider.setThumbImage(UIImage(named: "Slider"), for: .normal)
        slider.value = 0
        slider.minimumValue = 0.2
        slider.maximumValue = 1
        return slider
    }()
    
    private let importantSlider: CustomSlider = {
        let slider = CustomSlider()
        slider.addTarget(nil, action: #selector(CreateActivityViewController.sliderValueChanged(_:)), for: .valueChanged)
        slider.tag = 2
        slider.minimumTrackTintColor = .AppCollors.red
        slider.maximumTrackTintColor = .white.withAlphaComponent(0.5)
        slider.setThumbImage(UIImage(named: "Slider"), for: .normal)
        slider.value = 0
        slider.minimumValue = 0.2
        slider.maximumValue = 1
        return slider
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    func setSliderValue(value: Float, tag: Int) {
        switch tag {
        case 1:
            urgentSlider.value = value
        case 2:
            importantSlider.value = value
        default: break
        }
    }
    
    func changeSumImage(currentSum: Int) {
        pointImageView.image = UIImage(named: "x\(currentSum)")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        pointImageView.image = UIImage(named: "x8")
        let pointSize = resized(size: CGSize(width: 271, height: 157), basedOn: .height)
        addSubview(pointImageView)
        pointImageView.translatesAutoresizingMaskIntoConstraints = false
        pointImageView.widthAnchor.constraint(equalToConstant: pointSize.width).isActive = true
        pointImageView.heightAnchor.constraint(equalToConstant: pointSize.height).isActive = true
        pointImageView.centerXAnchor.constraint(equalTo: pointImageView.superview!.centerXAnchor).isActive = true
        pointImageView.topAnchor.constraint(equalTo: pointImageView.superview!.topAnchor, constant: -15).isActive = true
        
        addSubview(urgentLabel)
        urgentLabel.leftAnchor.constraint(equalTo: urgentLabel.superview!.leftAnchor, constant: 52).isActive = true
        urgentLabel.rightAnchor.constraint(equalTo: urgentLabel.superview!.rightAnchor, constant: -52).isActive = true
        urgentLabel.topAnchor.constraint(equalTo: pointImageView.bottomAnchor, constant: -10).isActive = true
        urgentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let adapted20 = adapted(dimensionSize: 20, to: .height)
        let adaptedTop10 = adapted(dimensionSize: 10, to: .height)
        addSubview(urgentCollectionView)
        urgentCollectionView.translatesAutoresizingMaskIntoConstraints = false
        urgentCollectionView.leftAnchor.constraint(equalTo: urgentCollectionView.superview!.leftAnchor,
                                                   constant: 52).isActive = true
        urgentCollectionView.heightAnchor.constraint(equalToConstant: adapted20).isActive = true
        urgentCollectionView.rightAnchor.constraint(equalTo: urgentCollectionView.superview!.rightAnchor, constant: 0).isActive = true
        urgentCollectionView.topAnchor.constraint(equalTo: urgentLabel.bottomAnchor, constant: adaptedTop10).isActive = true
        
        addSubview(urgentSlider)
        urgentSlider.topAnchor.constraint(equalTo: urgentCollectionView.bottomAnchor, constant: 5).isActive = true
        urgentSlider.leftAnchor.constraint(equalTo: urgentSlider.superview!.leftAnchor, constant: 52).isActive = true
        urgentSlider.rightAnchor.constraint(equalTo: urgentSlider.superview!.rightAnchor, constant: -52).isActive = true
        urgentSlider.heightAnchor.constraint(equalToConstant: adapted20).isActive = true
        urgentSlider.translatesAutoresizingMaskIntoConstraints = false
        
        let topDistanceImportLabel: CGFloat = UIScreen.current.rawValue <= 2 ? 10 : 25
        let importTop = adapted(dimensionSize: topDistanceImportLabel, to: .height)
        addSubview(importantLabel)
        importantLabel.leftAnchor.constraint(equalTo: importantLabel.superview!.leftAnchor, constant: 52).isActive = true
        importantLabel.rightAnchor.constraint(equalTo: importantLabel.superview!.rightAnchor, constant: -52).isActive = true
        importantLabel.topAnchor.constraint(equalTo: urgentSlider.bottomAnchor, constant: importTop).isActive = true
        importantLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(importantCollectionView)
        importantCollectionView.translatesAutoresizingMaskIntoConstraints = false
        importantCollectionView.leftAnchor.constraint(equalTo: importantCollectionView.superview!.leftAnchor,
                                             constant: 52).isActive = true
        importantCollectionView.heightAnchor.constraint(equalToConstant: adapted20).isActive = true
        importantCollectionView.rightAnchor.constraint(equalTo: importantCollectionView.superview!.rightAnchor, constant: 0).isActive = true
        importantCollectionView.topAnchor.constraint(equalTo: importantLabel.bottomAnchor, constant: adaptedTop10).isActive = true
        
        addSubview(importantSlider)
        importantSlider.topAnchor.constraint(equalTo: importantCollectionView.bottomAnchor, constant: 5).isActive = true
        importantSlider.leftAnchor.constraint(equalTo: importantSlider.superview!.leftAnchor, constant: 52).isActive = true
        importantSlider.rightAnchor.constraint(equalTo: importantSlider.superview!.rightAnchor, constant: -52).isActive = true
        importantSlider.heightAnchor.constraint(equalToConstant: adapted20).isActive = true
        importantSlider.translatesAutoresizingMaskIntoConstraints = false
    }

}
