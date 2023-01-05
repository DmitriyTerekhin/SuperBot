//
//  AppDelegate.swift
//  SortingBot
//

import UIKit
import IronSource

@main
class AppDelegate: UIResponder, UIApplicationDelegate, ISInitializationDelegate {
    
    enum Constants {
        static let IronAppKey = "18013d3ed"
        static let appHub = "app_j3hnXZuw2cSdFEacg8h4nkBqBQ7SV4"
    }

    var window: UIWindow?
    let rootAssembly = RootAssembly()
    let notificationCenter = UNUserNotificationCenter.current()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        notificationCenter.delegate = self
        setupFrameworks()
        if #available(iOS 13, *) { }
        else { createStartView(window: window ?? UIWindow(frame: UIScreen.main.bounds)) }
        return true
    }

    private func setupFrameworks() {
        IronSource.initWithAppKey(Constants.IronAppKey, delegate: self)
    }
    
    func initializationDidComplete() {
        ISIntegrationHelper.validateIntegration()
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    private func createStartView(window: UIWindow) {
        self.window = window
        let countryCheckScreen = rootAssembly.presentationAssembly.getCountryCheckScreen()
        window.rootViewController = countryCheckScreen
        window.makeKeyAndVisible()
    }
    
    func changeRootViewController(_ vc: UIViewController, animated: Bool = true) {
        guard
            let window = self.window,
            window.rootViewController != vc
        else {
            return
        }
        window.rootViewController = UINavigationController(rootViewController: vc)
        window.makeKeyAndVisible()
        UIView.transition(with: window,
                          duration: 0.3,
                          options: [.transitionCrossDissolve],
                          animations: nil,
                          completion: nil)
    }

}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if #available(iOS 14.0, *) {
            completionHandler([.sound, .badge, .banner])
        } else {
            completionHandler([.alert, .sound, .badge])
        }
    }
    
    func application( _ application: UIApplication,
                      didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        rootAssembly.serviceAssembly.userInfoService.saveNotificationToken(token: token)
        rootAssembly.serviceAssembly.networkService.sendPushToken(token: token,
                                                                  countryCode: rootAssembly.serviceAssembly.userInfoService.getCountry())
    }

    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        print("Failed to register: \(error)")
    }
}
