//
//  CreateActivityViewController.swift
//  SortingBot
//
//  Created by Дмитрий Терехин on 27.12.2022.
//

import UIKit
import IronSource
import AdSupport

class CreateActivityViewController: UIViewController {
    
    private let presenter: ICreateActivityPresenter
    private var agreeWithPrivacy = true
    private var agreeWithTerms = true
    private var agreeWithUserContent = true
    private let contentView = CreateActivityView()
    private let numbersDataSource: [Int] = [1,2,3,4,5]
    private var allAgree: Bool {
        guard agreeWithTerms else { return false }
        guard agreeWithPrivacy else { return false }
        guard agreeWithUserContent else { return false}
        return true
    }
    private var viewState: CreateActivityViewState = .start {
        didSet {
            contentView.prepareForState(viewState)
        }
    }
    
    init(presenter: ICreateActivityPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
        presenter.attachView(view: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        IronSource.setRewardedVideoDelegate(self)
    }
    
    private func setupView() {
        contentView.changeSumImage(currentSum: presenter.currentPointSum)
        contentView.givePointView.importantCollectionView.dataSource = self
        contentView.givePointView.urgentCollectionView.dataSource = self
        contentView.givePointView.importantCollectionView.delegate = self
        contentView.givePointView.urgentCollectionView.delegate = self
        contentView.imagePickerController.delegate = self
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @objc
    func mainButtonTapped() {
        switch viewState {
        case .start:
            if !presenter.isPremiumActive() && IronSource.hasRewardedVideo() {
                IronSource.showRewardedVideo(with: self, placement: nil)
            } else {
                afterShowingAdd()
            }

        case .creatingActivity:
            guard presenter.nameAndPhotoWasInserted else { return }
            viewState = .addingPoints
        case .addingPoints:
            contentView.showCurrentImage(imageData: presenter.currentImageData)
            viewState = .finalResult
        case .finalResult:
            guard allAgree else { return }
            presenter.saveActivity()
            (tabBarController as? CustomTabBarController)?.showScreen(.history)
            viewState = .start
            contentView.clearView()
            presenter.deleteActivityModel()
        }
    }
    
    @objc
    func backButtonTapped() {
        switch viewState {
        case .start:
            break
        case .creatingActivity:
            viewState = .start
        case .addingPoints:
            viewState = .creatingActivity
            contentView.enableMainButton(forceDisable: !presenter.nameAndPhotoWasInserted)
        case .finalResult:
            viewState = .addingPoints
        }
    }
    
    @objc
    func choosePhotoButtonTapped() {
        present(contentView.imagePickerController, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc
    func checkBoxTapped(sender: UIButton) {
        switch sender.tag {
        case 1:
            contentView.privacyCheckBox.checkBoxButtonTapped()
            agreeWithPrivacy = contentView.privacyCheckBox.turnOn
        case 2:
            contentView.termsCheckBox.checkBoxButtonTapped()
            agreeWithTerms = contentView.termsCheckBox.turnOn
        case 3:
            contentView.userGeneratedCheckBox.checkBoxButtonTapped()
            agreeWithUserContent = contentView.userGeneratedCheckBox.turnOn
        default:
            break
        }
        contentView.enableMainButton(forceDisable: !allAgree)
    }
    
    @objc
    func sliderValueChanged(_ sender: Any) {
        guard
            let value = (sender as? UISlider)?.value,
            let tag = (sender as? UISlider)?.tag
        else { return }
        let roundedValue = roundf(value / 0.2) * 0.2
        contentView.setSliderValue(value: roundedValue, tag: tag)
        switch tag {
        case 1:
            presenter.saveUrgentValue(Int(roundedValue * 5))
            contentView.givePointView.urgentCollectionView.reloadData()
        case 2:
            presenter.saveImportantValue(Int(roundedValue * 5))
            contentView.givePointView.importantCollectionView.reloadData()
        default:
            break
        }
    }
    
    private func afterShowingAdd() {
        viewState = .creatingActivity
        contentView.enableMainButton(forceDisable: !presenter.nameAndPhotoWasInserted)
    }

}

extension CreateActivityViewController: UITextFieldDelegate {
    @objc
    func textFieldValueDidChanged(sender: UITextField) {
        presenter.nameDidChanged(text: sender.text)
    }
}

// MARK: - UIView
extension CreateActivityViewController: ICreateActivityView {
    
    func changeSumValue(sum: Int) {
        contentView.changeSumImage(currentSum: sum)
    }
    
    func allowToSaveName(_ isAllow: Bool) {
        contentView.allowToSaveName(isAllow)
        contentView.enableMainButton(forceDisable: !presenter.nameAndPhotoWasInserted)
    }
    
    func allowToSavePhoto(_ isAllow: Bool) {
        contentView.allowToSavePhoto(isAllow)
        contentView.enableMainButton(forceDisable: !presenter.nameAndPhotoWasInserted)
    }
}

// MARK: - UICollectionView dataSource
extension CreateActivityViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/5, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numbersDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NumberCollectionViewCell.reuseID, for: indexPath) as! NumberCollectionViewCell
        var value: Int = 0
        switch collectionView {
        case contentView.givePointView.urgentCollectionView:
            value = numbersDataSource[safe: indexPath.row] ?? 0
            cell.prepare(with: String(value), isActive: presenter.currentUrgent == value)
        case contentView.givePointView.importantCollectionView:
            value = numbersDataSource[safe: indexPath.row] ?? 0
            cell.prepare(with: String(value), isActive: presenter.currentImportant == value)
        default:
            break
        }
        return cell
    }
}

// MARK: - Image Picker
extension CreateActivityViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
 
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let tempImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        picker.dismiss(animated: true, completion: nil)
        guard let image = tempImage,
              let imageData = image.fixedOrientation().jpegData(compressionQuality: 1.0)
        else { return }
        presenter.saveImage(data: imageData)
    }
    
}

//MARK: - IronSource video delegate
extension CreateActivityViewController: ISRewardedVideoDelegate {
    func rewardedVideoHasChangedAvailability(_ available: Bool) {
        print("video is available == \(available)")
    }

    func didReceiveReward(forPlacement placementInfo: ISPlacementInfo!) {}

    func rewardedVideoDidFailToShowWithError(_ error: Error!) {}

    func rewardedVideoDidOpen() {}

    func rewardedVideoDidStart() {}

    func rewardedVideoDidEnd() {
        afterShowingAdd()
    }

    func didClickRewardedVideo(_ placementInfo: ISPlacementInfo!) {}

    // Iron Source delegate
    public func rewardedVideoDidClose() {
        afterShowingAdd()
    }
}

private extension UIImage {
    func fixedOrientation() -> UIImage {

        if imageOrientation == .up {
            return self
        }

        var transform: CGAffineTransform = CGAffineTransform.identity

        switch imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat.pi)
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat.pi / 2)
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: CGFloat.pi / -2)
        case .up, .upMirrored:
            break
        }

        switch imageOrientation {
        case .upMirrored, .downMirrored:
            transform.translatedBy(x: size.width, y: 0)
            transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform.translatedBy(x: size.height, y: 0)
            transform.scaledBy(x: -1, y: 1)
        case .up, .down, .left, .right:
            break
        }

        if let cgImage = self.cgImage, let colorSpace = cgImage.colorSpace,
            let ctx: CGContext = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) {
            ctx.concatenate(transform)

            switch imageOrientation {
            case .left, .leftMirrored, .right, .rightMirrored:
                ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
            default:
                ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            }
            if let ctxImage: CGImage = ctx.makeImage() {
                return UIImage(cgImage: ctxImage)
            } else {
                return self
            }
        } else {
            return self
        }
    }
}
