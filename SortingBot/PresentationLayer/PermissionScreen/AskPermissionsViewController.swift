//
//  AskPermissionsViewController.swift
//  SortingBot
//
//  Created by Дмитрий Терехин on 26.12.2022.
//

import UIKit
import CoreLocation
import NotificationCenter

class AskPermissionsViewController: UIViewController {
    
    private let contentView = AskPermissionView()
    private let presentationAssembly: IPresentationAssembly
    private let userInfoService: ISensentiveInfoService
    private let linkToGo: String?
    
    init(
        presentationAssembly: IPresentationAssembly,
        userInfoService: ISensentiveInfoService,
        link: String? = nil
    ) {
        self.presentationAssembly = presentationAssembly
        self.userInfoService = userInfoService
        self.linkToGo = link
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @objc
    func allowTapped() {
        registerForPushNotifications {
            self.userInfoService.changeAskPushValue()
            DispatchQueue.main.async {
                self.skipTapped()
            }
        }
    }
    
    @objc
    func skipTapped() {
        userInfoService.changeAskPushValue()
        guard
            let link = linkToGo
        else {
            let enterVC = presentationAssembly.enterScreen()
            navigationController?.pushViewController(enterVC, animated: true)
            return
        }
        let webview = presentationAssembly.webViewController(site: "", title: nil)
        navigationController?.pushViewController(webview, animated: true)
    }
    
    private func registerForPushNotifications(completionHandler: @escaping () -> Void) {
      UNUserNotificationCenter.current()
        .requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, _ in
            completionHandler()
            guard granted else { return }
            self?.getNotificationSettings()
        }
    }
    
    private func getNotificationSettings() {
      UNUserNotificationCenter.current().getNotificationSettings { settings in
        print("Notification settings: \(settings)")
          guard settings.authorizationStatus == .authorized else { return }
          DispatchQueue.main.async {
            UIApplication.shared.registerForRemoteNotifications()
          }
      }
    }

}
