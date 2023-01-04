//
//  CreateActivityPresenter.swift
//  SortingBot
//
//  Created by Дмитрий Терехин on 28.12.2022.
//

import Foundation
import ApphudSDK

protocol ICreateActivityPresenter: AnyObject {
    var nameAndPhotoWasInserted: Bool { get }
    var currentPointSum: Int { get }
    var currentUrgent: Int { get }
    var currentImportant: Int { get }
    var currentImageData: Data? { get }
    func nameDidChanged(text: String?)
    func attachView(view: ICreateActivityView)
    func saveImage(data: Data)
    func saveImportantValue(_ value: Int)
    func saveUrgentValue(_ value: Int)
    func deleteActivityModel()
    func saveActivity()
    func isPremiumActive() -> Bool
}

protocol ICreateActivityView: AnyObject {
    func allowToSaveName(_ isAllow: Bool)
    func allowToSavePhoto(_ isAllow: Bool)
    func changeSumValue(sum: Int)
}

class CreateActivityPresenter: ICreateActivityPresenter {
    weak var view: ICreateActivityView?
    var currentPointSum: Int {
        return activityModel.howUrgent + activityModel.howImportant
    }
    var currentUrgent: Int { return activityModel.howUrgent }
    var currentImportant: Int {  return activityModel.howImportant }
    var currentImageData: Data? { return activityModel.image }
    private let databaseService: IDatabaseService
    private let userInfoService: ISensentiveInfoService
    private let productService: IProductService
    
    var activityModel: ActivityModel = ActivityModel()
    
    var nameAndPhotoWasInserted: Bool {
        return activityModel.image != nil && activityModel.name.count >= 3
    }
    
    init(
        databaseService: IDatabaseService,
        sensetiveUserService: ISensentiveInfoService,
        purchasesService: IProductService
    ) {
        self.databaseService = databaseService
        self.userInfoService = sensetiveUserService
        self.productService = purchasesService
    }
    
    func saveImportantValue(_ value: Int) {
        activityModel.howImportant = value
        view?.changeSumValue(sum: currentPointSum)
    }
    
    func saveUrgentValue(_ value: Int) {
        activityModel.howUrgent = value
        view?.changeSumValue(sum: currentPointSum)
    }
    
    func attachView(view: ICreateActivityView) {
        self.view = view
    }
    
    func nameDidChanged(text: String?) {
        activityModel.name = text ?? ""
        view?.allowToSaveName((text ?? "").count >= 3)
    }
    
    func saveImage(data: Data) {
        activityModel.image = data
        view?.allowToSavePhoto(true)
    }
    
    func deleteActivityModel() {
        activityModel = ActivityModel()
    }
    
    func isPremiumActive() -> Bool {
        return Apphud.isNonRenewingPurchaseActive(productIdentifier: productService.removeAdsId) || userInfoService.isPremiumActive()
    }
    
    func saveActivity() {
        databaseService.saveResult(result: activityModel, completionHandler: {_ in})
    }
}
