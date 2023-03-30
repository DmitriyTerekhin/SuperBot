//
//  CreateActivityView.swift
//  SortingBot
//
//  Created by Дмитрий Терехин on 27.12.2022.
//

import UIKit

class CreateActivityView: UIView {
    
    private enum Constants {
        static let title: String = "To get started, please create an account.\n\nThis will allow you to access all of our features and personalize your experience.\n\nDon't worry, we'll never share your information with third parties. If you have any questions or need assistance, please don't hesitate to contact us."
        static let createTitle: String = "Create Activity"
        static let nextTitle: String = "Next"
        static let confirmTitle: String = "Confirm"
        static let attachPhotoTitle: String = "Attach photo"
        static let attachedPhotoTitle: String = "Photo attached"
        static let nameOfActivity: String = "Name of activity"
        static let buttonSize = resized(size: CGSize(width: 271, height: 60), basedOn: .height)
        
        static let privacyText: String = "I agree with Privacy policy of service"
        static let privacyClickableText: String = "Privacy policy"
        static let privacySite: String = "\(ApiConstants.URL.mainURL)/privacy.html"
        static let termsAndConditionsText: String = "I agree with Terms and conditions of service"
        static let termsAndConditionsSite: String = "\(ApiConstants.URL.mainURL)/terms.html"
        static let termsAndConditionsClickableText: String = "Terms and conditions"
        static let userGeneratedText: String = "I agree with user generated content rules of service"
        static let userGeneratedSite: String = "\(ApiConstants.URL.mainURL)/content.html"
        static let userGeneratedClickableText: String = "user generated content rules"
    }
    
    let imagePickerController: UIImagePickerController = {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        return imagePickerController
    }()
    
    private let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Small_logo")
        iv.setContentCompressionResistancePriority(.required, for: .vertical)
        return iv
    }()
    
    private let equipmentsImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "CreateActivityStartImage")
        return iv
    }()
    
    private let nameOfActivityTextField: UITextField = {
        let tf = UITextField()
        tf.layer.cornerRadius = 10
        tf.layer.borderWidth = 2
        tf.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        tf.tintColor = UIColor.white.withAlphaComponent(0.5)
        tf.textAlignment = .center
        tf.isHidden = true
        tf.placeholder = Constants.nameOfActivity
        tf.attributedPlaceholder = NSAttributedString(
            string: Constants.nameOfActivity,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.5)]
        )
        tf.textColor = UIColor.white.withAlphaComponent(0.5)
        tf.font = UIFont(font: .KanitBold, size: 20)
        tf.addTarget(nil, action: #selector(CreateActivityViewController.textFieldValueDidChanged), for: .editingChanged)
        return  tf
    }()
    
    let givePointView: CreateActivityPointsView = {
        let view = CreateActivityPointsView()
        view.isHidden = true
        return view
    }()
    
    private let finalView: CreateActivityFinalView = {
        let view = CreateActivityFinalView()
        view.isHidden = true
        return view
    }()
    
    private let backButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "BackButton"), for: .normal)
        btn.isHidden = true
        btn.tintColor = .white
        return btn
    }()
    
    private let attachPhotoButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.isHidden = true
        btn.addTarget(nil, action: #selector(CreateActivityViewController.choosePhotoButtonTapped), for: .touchUpInside)
        btn.setTitle(Constants.attachPhotoTitle, for: .normal)
        btn.tintColor = .white.withAlphaComponent(0.5)
        btn.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        btn.layer.borderWidth = 2
        btn.titleLabel?.setFont(fontName: .KanitBold, sizeXS: 20)
        if #available(iOS 15, *) {
            var config = UIButton.Configuration.plain()
            config.background.backgroundColor = UIColor.clear
            config.background.cornerRadius = 10
            config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                outgoing.font = UIFont(font: .KanitBold, size: 20)
                return outgoing
            }
            btn.configuration = config
        } else {
            btn.backgroundColor = .clear
            btn.titleLabel?.setFont(fontName: .KanitBold, sizeXS: 20)
        }
        btn.layer.cornerRadius = 10
        btn.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .normal)
        return btn
    }()
    
    private let mainButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.addTarget(nil, action: #selector(CreateActivityViewController.mainButtonTapped), for: .touchUpInside)
        btn.setTitle(Constants.createTitle, for: .normal)
        btn.setImage(UIImage(named: "CreateActivityTab")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = .white
        btn.titleLabel!.setFont(fontName: .KanitBold, sizeXS: 20)
        if #available(iOS 15, *) {
            var config = UIButton.Configuration.plain()
            config.imagePadding = 10
            config.background.backgroundColor = UIColor.AppCollors.red
            config.background.cornerRadius = 10
            config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                outgoing.font = UIFont(font: .KanitBold, size: 20)
                return outgoing
            }
            btn.configuration = config
        } else {
            btn.imageEdgeInsets.right = 15
            btn.backgroundColor = .AppCollors.red
        }
        btn.layer.cornerRadius = 10
        btn.setTitleColor(.white, for: .normal)
        return btn
    }()
    
    let privacyCheckBox: CheckBoxButtonView = {
        let cb = CheckBoxButtonView()
        cb.addText(text: Constants.privacyText as NSString,
                   wordsInText: Constants.privacyClickableText,
                   siteToGo: Constants.privacySite)
        cb.checkBoxButton.tag = 1
        cb.checkBoxButton.addTarget(nil, action: #selector(CreateActivityViewController.checkBoxTapped), for: .touchUpInside)
        return cb
    }()
    
    let termsCheckBox: CheckBoxButtonView = {
        let cb = CheckBoxButtonView()
        cb.addText(text: Constants.termsAndConditionsText as NSString,
                   wordsInText: Constants.termsAndConditionsClickableText,
                   siteToGo: Constants.termsAndConditionsSite)
        cb.checkBoxButton.tag = 2
        cb.checkBoxButton.addTarget(nil, action: #selector(CreateActivityViewController.checkBoxTapped), for: .touchUpInside)
        return cb
    }()
    
    let userGeneratedCheckBox: CheckBoxButtonView = {
        let cb = CheckBoxButtonView()
        cb.addText(text: Constants.userGeneratedText as NSString,
                   wordsInText: Constants.userGeneratedClickableText,
                   siteToGo: Constants.userGeneratedSite)
        cb.checkBoxButton.tag = 3
        cb.checkBoxButton.addTarget(nil, action: #selector(CreateActivityViewController.checkBoxTapped), for: .touchUpInside)
        return cb
    }()
    
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.isHidden = true
        return sv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSliderValue(value: Float, tag: Int) {
        givePointView.setSliderValue(value: value, tag: tag)
    }
    
    func allowToSavePhoto(_ isAllow: Bool) {
        if #available(iOS 15, *) {
            var config = UIButton.Configuration.plain()
            config.background.backgroundColor = isAllow ? UIColor.AppCollors.red : UIColor.clear
            config.background.cornerRadius = 10
            config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                outgoing.font = UIFont(font: .KanitBold, size: 20)
                return outgoing
            }
            attachPhotoButton.configuration = config
        } else {
            attachPhotoButton.backgroundColor = isAllow ? .AppCollors.red : .clear
        }
        let color = isAllow ? UIColor.white : UIColor.white.withAlphaComponent(0.5)
        let title = isAllow ? Constants.attachedPhotoTitle : Constants.attachPhotoTitle
        attachPhotoButton.layer.borderColor = isAllow ? UIColor.AppCollors.red.cgColor : UIColor.white.withAlphaComponent(0.5).cgColor
        attachPhotoButton.setTitleColor(color, for: .normal)
        attachPhotoButton.setTitle(title, for: .normal)
    }
    
    func allowToSaveName(_ isAllow: Bool) {
        nameOfActivityTextField.textColor = isAllow ? UIColor.white : UIColor.white.withAlphaComponent(0.5)
        nameOfActivityTextField.layer.borderColor = isAllow ? UIColor.AppCollors.red.cgColor : UIColor.white.withAlphaComponent(0.5).cgColor
    }
    
    func showCurrentImage(imageData: Data?) {
        guard
            let data = imageData,
            let image = UIImage(data: data)
        else { return }
        finalView.activityImageView.image = image
    }
    
    func prepareForState(_ viewState: CreateActivityViewState) {
        switch viewState {
        case .start:
            backButton.isHidden = true
            mainButton.setTitle(Constants.createTitle, for: .normal)
            enableMainButton()
            mainButton.setImage(UIImage(named: "CreateActivityTab")?.withRenderingMode(.alwaysTemplate), for: .normal)
            mainButton.isHidden = false
            equipmentsImageView.isHidden = false
            finalView.isHidden = true
            stackView.isHidden = true
            attachPhotoButton.isHidden = true
            nameOfActivityTextField.isHidden = true
        case .creatingActivity:
            givePointView.isHidden = true
            backButton.isHidden = false
            equipmentsImageView.isHidden = true
            attachPhotoButton.isHidden = false
            nameOfActivityTextField.isHidden = false
            mainButton.setImage(UIImage(), for: .normal)
            mainButton.setTitle(Constants.nextTitle, for: .normal)
            enableMainButton(forceDisable: true)
        case .addingPoints:
            mainButton.setTitle(Constants.nextTitle, for: .normal)
            finalView.isHidden = true
            stackView.isHidden = true
            attachPhotoButton.isHidden = true
            givePointView.isHidden = false
            enableMainButton()
            nameOfActivityTextField.isHidden = true
        case .finalResult:
            mainButton.setTitle(Constants.confirmTitle, for: .normal)
            finalView.setTitle(text: nameOfActivityTextField.text)
            givePointView.isHidden = true
            finalView.isHidden = false
            stackView.isHidden = false
        }
    }
    
    func enableMainButton(forceDisable: Bool = false) {
        guard
            !forceDisable
        else {
            mainButton.backgroundColor = UIColor(netHex: 0x323232)
            return
        }
        mainButton.alpha = 1
        mainButton.backgroundColor = UIColor.AppCollors.red
    }
    
    func changeSumImage(currentSum: Int) {
        givePointView.changeSumImage(currentSum: currentSum)
        finalView.changeSumImage(currentSum: currentSum)
    }
    
    func clearView() {
        nameOfActivityTextField.text = nil
        setSliderValue(value: 0.2, tag: 1)
        setSliderValue(value: 0.2, tag: 2)
        allowToSavePhoto(false)
        allowToSaveName(false)
        changeSumImage(currentSum: 2)
        
    }
    
    private func setupView() {
        backgroundColor = .AppCollors.backgroundBlack
        backButton.addTarget(nil, action: #selector(CreateActivityViewController.backButtonTapped), for: .touchUpInside)
        
        addSubview(logoImageView)
        addSubview(mainButton)
        addSubview(equipmentsImageView)
        addSubview(backButton)
        
        // create
        addSubview(nameOfActivityTextField)
        addSubview(attachPhotoButton)
        
        // give points
        addSubview(givePointView)
        
        //final result
        addSubview(finalView)
        addSubview(stackView)
        let sizeLogo = resized(size: CGSize(width: 67, height: 86), basedOn: .height)
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: logoImageView.superview!.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: logoImageView.superview!.safeTopAnchor,
                                               constant: 46),
            logoImageView.widthAnchor.constraint(equalToConstant: sizeLogo.width),
            logoImageView.heightAnchor.constraint(equalToConstant: sizeLogo.height)
        ])
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backButton.centerYAnchor.constraint(equalTo: logoImageView.centerYAnchor),
            backButton.leftAnchor.constraint(equalTo: backButton.superview!.leftAnchor, constant: 56)
        ])
        
        mainButton.translatesAutoresizingMaskIntoConstraints = false
        let bottomDistance = adapted(dimensionSize: 175, to: .height)
        NSLayoutConstraint.activate([
            mainButton.widthAnchor.constraint(equalToConstant: Constants.buttonSize.width),
            mainButton.heightAnchor.constraint(equalToConstant: Constants.buttonSize.height),
            mainButton.centerXAnchor.constraint(equalTo: mainButton.superview!.centerXAnchor),
            mainButton.bottomAnchor.constraint(equalTo: mainButton.superview!.bottomAnchor,
                                                 constant: -bottomDistance),
        ])
        let topDistance = adapted(dimensionSize: 56, to: .height)
        equipmentsImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            equipmentsImageView.centerXAnchor.constraint(equalTo: equipmentsImageView.superview!.centerXAnchor),
            equipmentsImageView.bottomAnchor.constraint(equalTo: mainButton.topAnchor,
                                                     constant: -topDistance)
        ])
        // Creating view
        nameOfActivityTextField.translatesAutoresizingMaskIntoConstraints = false
        nameOfActivityTextField.widthAnchor.constraint(equalToConstant: Constants.buttonSize.width).isActive = true
        nameOfActivityTextField.heightAnchor.constraint(equalToConstant: Constants.buttonSize.height).isActive = true
        nameOfActivityTextField.centerXAnchor.constraint(equalTo: nameOfActivityTextField.superview!.centerXAnchor).isActive = true
        nameOfActivityTextField.bottomAnchor.constraint(equalTo: nameOfActivityTextField.superview!.centerYAnchor, constant: -5).isActive = true
        
        attachPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        attachPhotoButton.widthAnchor.constraint(equalToConstant: Constants.buttonSize.width).isActive = true
        attachPhotoButton.heightAnchor.constraint(equalToConstant: Constants.buttonSize.height).isActive = true
        attachPhotoButton.centerXAnchor.constraint(equalTo: attachPhotoButton.superview!.centerXAnchor).isActive = true
        attachPhotoButton.topAnchor.constraint(equalTo: attachPhotoButton.superview!.centerYAnchor, constant: 5).isActive = true
        
        // Give points
        givePointView.translatesAutoresizingMaskIntoConstraints = false
        givePointView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 0).isActive = true
        givePointView.leftAnchor.constraint(equalTo: givePointView.superview!.leftAnchor).isActive = true
        givePointView.rightAnchor.constraint(equalTo: givePointView.superview!.rightAnchor).isActive = true
        givePointView.bottomAnchor.constraint(equalTo: mainButton.topAnchor, constant: -10).isActive = true
        givePointView.translatesAutoresizingMaskIntoConstraints = false
        
        // final result
        finalView.translatesAutoresizingMaskIntoConstraints = false
        finalView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 37).isActive = true
        finalView.leftAnchor.constraint(equalTo: finalView.superview!.leftAnchor).isActive = true
        finalView.rightAnchor.constraint(equalTo: finalView.superview!.rightAnchor).isActive = true
        finalView.bottomAnchor.constraint(equalTo: mainButton.topAnchor, constant: -10).isActive = true
        finalView.translatesAutoresizingMaskIntoConstraints = false
        
        // StackView
        stackView.topAnchor.constraint(equalTo: mainButton.bottomAnchor, constant: 4).isActive = true
        stackView.bottomAnchor.constraint(lessThanOrEqualTo: stackView.superview!.bottomAnchor,
                                          constant: -10).isActive = true
        stackView.leftAnchor.constraint(equalTo: mainButton.leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: mainButton.rightAnchor).isActive = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // PrivacyCheckBox
        stackView.addArrangedSubview(privacyCheckBox)
        privacyCheckBox.heightAnchor.constraint(equalToConstant: 18).isActive = true
        privacyCheckBox.translatesAutoresizingMaskIntoConstraints = false
        
        // TermsCheckBox
        stackView.addArrangedSubview(termsCheckBox)
        termsCheckBox.heightAnchor.constraint(equalToConstant: 18).isActive = true
        termsCheckBox.translatesAutoresizingMaskIntoConstraints = false
        
        // UserGeneratedCheckBox
        stackView.addArrangedSubview(userGeneratedCheckBox)
        userGeneratedCheckBox.heightAnchor.constraint(equalToConstant: 18).isActive = true
        userGeneratedCheckBox.translatesAutoresizingMaskIntoConstraints = false
        
    }

}
