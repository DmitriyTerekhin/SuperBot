//
//  SettingsPresenter.swift
//  SortingBot
//
//  Created by Дмитрий Терехин on 27.12.2022.
//

import Foundation
import ApphudSDK

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
    private var product: ApphudProduct?
    
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
        loadproducts()
    }
    
    private func loadproducts() {
        Apphud.paywallsDidLoadCallback { [weak self] paywalls in
            guard let strongSelf = self else { return }
            let message = "paywalls = \(paywalls.count)\n products:\(paywalls.first!.products.first!.productId)"
            paywalls.forEach { wall in
                strongSelf.product = wall.products.first(where: {$0.productId == strongSelf.purchasesService.removeAdsId})
            }
        }
    }
    
    func getDataSource() -> [SettingType] {
        var source: [SettingType] = [
            SettingType.feedback,
            SettingType.privacy,
            SettingType.terms,
            SettingType.restorePurchases,
            SettingType.deleteAccount
        ]
        let message =
        " Is nonRenewingActive active = \(Apphud.isNonRenewingPurchaseActive(productIdentifier: purchasesService.removeAdsId)) \n Has premium access = \(Apphud.hasPremiumAccess())"
        view?.showMessage(text: message)
        
        if !Apphud.isNonRenewingPurchaseActive(productIdentifier: purchasesService.removeAdsId) {
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
        if let product = product {
            self.view?.showMessage(text: "Found Product")
            Apphud.purchase(product) { [weak self] result in
                self?.checkPurchases(result)
            }
        } else {
            Apphud.purchase(purchasesService.removeAdsId) { [weak self] result
                in
                self?.checkPurchases(result)
            }
        }
    }
    
    private func checkPurchases(_ result: ApphudPurchaseResult) {
        if result.success {userInfoService.savePremium()}
        validateCheck(completion: { [weak self] _ in
            self?.view?.hideLoader()
            self?.view?.updateTable()
        })
    }
    
    private func validateCheck(completion: @escaping (Bool) -> Void) {
        Apphud.validateReceipt { [weak self] subscriptions, nonRenewinPurchases, error in
            guard let strongSelf = self else { return }
            if let removeAdds = subscriptions?.first(where: {$0.productId == strongSelf.purchasesService.removeAdsId}),
               removeAdds.isActive()
            {
                completion(true)
            }
            if let removeAdds = nonRenewinPurchases?.first(where: {$0.productId == strongSelf.purchasesService.removeAdsId}),
               removeAdds.isActive()
            {
                completion(true)
            }
            completion(false)
        }
    }
    
    private func deleteAccount() {
        networkService.deleteProfile { [weak self] result in
            DispatchQueue.main.async {
                guard let strongSelf = self else { return }
                switch result {
                case .success(_):
                    Apphud.logout()
                    strongSelf.revokeAppleToken()
                    strongSelf.goToEnterScreen()
                case .failure(_):
                    strongSelf.goToEnterScreen()
                }
            }
        }
    }
    
    private func restorePurchases() {
        Apphud.restorePurchases { [weak self] _, _, _
            in
            self?.view?.updateTable()
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

extension ApphudPurchaseResult {
    var success: Bool {
        subscription?.isActive() ?? false ||
        nonRenewingPurchase?.isActive() ?? false ||
        (Apphud.isSandbox() && transaction?.transactionState == .purchased)
    }
}
