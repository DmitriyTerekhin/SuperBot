//
//  SettingsPresenter.swift
//  SortingBot
//
//  Created by Дмитрий Терехин on 27.12.2022.
//

import Foundation

protocol ISettingsPresenter: AnyObject {
    func attachView(view: ISettingsView)
    func getDataSource() -> [SettingType]
    func settingWasTapped(type: SettingType)
}

protocol ISettingsView: AnyObject {
    func routeToWebSite(_ site: String)
    func showMessage(text: String)
    func showLoader()
    func hideLoader()
    func routeToEnterScreen()
    func updateTable()
}

class SettingsPresenter: ISettingsPresenter {
    
    private weak var view: ISettingsView?
    private let networkService: INetworkService
    private let userInfoService: ISensentiveInfoService
    private let purchasesService: IProductService
    
    init(
        networkService: INetworkService,
        userInfoService: ISensentiveInfoService,
        productService: IProductService
    ) {
        self.networkService = networkService
        self.userInfoService = userInfoService
        self.purchasesService = productService
    }
    
    func attachView(view: ISettingsView) {
        self.view = view
    }
    
    func getDataSource() -> [SettingType] {
        var source: [SettingType] = [
            SettingType.feedback,
            SettingType.privacy,
            SettingType.terms,
            SettingType.restorePurchases,
            SettingType.deleteAccount
        ]
        
        if !userInfoService.isPremiumActive() {
            source.insert(SettingType.buyPremium, at: 0)
        }
        return source
    }
    
    func settingWasTapped(type: SettingType) {
        switch type {
        case .buyPremium:
            buyRemoveAdd()
        case .feedback:
            view?.routeToWebSite("\(ApiConstants.URL.mainURL)/#three")
        case .privacy:
            view?.routeToWebSite("\(ApiConstants.URL.mainURL)/privacy.html")
        case .terms:
            view?.routeToWebSite("\(ApiConstants.URL.mainURL)/terms.html")
        case .restorePurchases:
            restorePurchases()
        case .deleteAccount:
            deleteAccount()
        }
    }
    
    func buyRemoveAdd() {
        view?.showLoader()
        purchasesService.buyAddsOff { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self?.userInfoService.savePremium()
                    self?.view?.hideLoader()
                    self?.view?.updateTable()
                case .failure(let error):
                    self?.view?.showMessage(text: error.localizedDescription)
                }
            }
        }
    }
    
    private func deleteAccount() {
        networkService.deleteProfile { [weak self] result in
            DispatchQueue.main.async {
                guard let strongSelf = self else { return }
                switch result {
                case .success(_):
                    strongSelf.revokeAppleToken()
                    strongSelf.goToEnterScreen()
                case .failure(_):
                    strongSelf.goToEnterScreen()
                }
            }
        }
    }
    
    private func restorePurchases() {
        purchasesService.restorePurchases { [weak self] result in
            switch result {
            case .success(_):
                self?.userInfoService.savePremium()
                self?.view?.hideLoader()
                self?.view?.updateTable()
            case .failure(let error):
                self?.view?.showMessage(text: error.localizedDescription)
            }
        }
    }
    
    private func revokeAppleToken() {
        guard let appleToken = userInfoService.getAppleToken() else { return }
        networkService.revokeToken(appleId: appleToken)
    }
    
    private func goToEnterScreen() {
        userInfoService.deleteAllInfo { _ in
            self.view?.routeToEnterScreen()
        }
    }
}
