//
//  PresentationAssembly.swift
//  SortingBot
//
//  Created by Дмитрий Терехин on 26.12.2022.
//

import UIKit

protocol IPresentationAssembly {
    func enterScreen() -> EnterViewController
    func askPermissionsScreen(link: String?) -> AskPermissionsViewController
    func tabbarController() -> CustomTabBarController
    func createActivityScreen() -> CreateActivityViewController
    func activityHistoryScreen() -> ActivityHistoryViewController
    func webViewController(site: String, title: String?) -> WebViewViewController
    func settingsScreen() -> SettingsViewController
    func getCountryCheckScreen() -> LaunchScreenViewController
    func getLoaderScreen() -> LoaderViewController
}

class PresentationAssembly: IPresentationAssembly {
    
    let serviceAssembly: IServiceAssembly
    
    init(serviceAssembly: IServiceAssembly) {
        self.serviceAssembly = serviceAssembly
    }
    
    func getCountryCheckScreen() -> LaunchScreenViewController {
        LaunchScreenViewController(networkService: serviceAssembly.networkService,
                                   presentationAssembly: self,
                                   userInfoService: serviceAssembly.userInfoService,
                                   purchasesService: serviceAssembly.purchasesService,
                                   contentView: LaunchScreenView())
    }

    func enterScreen() -> EnterViewController {
        EnterViewController(presentationAssembly: self,
                            userInfoService: serviceAssembly.userInfoService,
                            networkService: serviceAssembly.networkService)
    }

    func webViewController(site: String, title: String? = nil) -> WebViewViewController {
        WebViewViewController(site: site, title: title)
    }

    func askPermissionsScreen(link: String?) -> AskPermissionsViewController {
        AskPermissionsViewController(presentationAssembly: self,
                                     userInfoService: serviceAssembly.userInfoService)
    }
    
    func createActivityScreen() -> CreateActivityViewController {
        CreateActivityViewController(presenter: CreateActivityPresenter(databaseService: serviceAssembly.databaseService,
                                                                        sensetiveUserService: serviceAssembly.userInfoService))
    }

    func activityHistoryScreen() -> ActivityHistoryViewController {
        ActivityHistoryViewController(databaseService: serviceAssembly.databaseService)
    }

    func settingsScreen() -> SettingsViewController {
        return SettingsViewController(
            presenter: SettingsPresenter(networkService: serviceAssembly.networkService,
                                         userInfoService: serviceAssembly.userInfoService,
                                         productService: serviceAssembly.purchasesService
                                        ),
            presentationAssembly: self
        )
    }

    func tabbarController() -> CustomTabBarController {
        CustomTabBarController(tabBar: CustomTabBar(presentationAssembly: self))
    }

    func getLoaderScreen() -> LoaderViewController {
        let loaderVC = LoaderViewController()
        loaderVC.modalPresentationStyle = .overCurrentContext
        return loaderVC
    }
    
}
