//
//  EnterViewController.swift
//  SortingBot
//
//  Created by Дмитрий Терехин on 26.12.2022.
//

import UIKit
import AuthenticationServices

class EnterViewController: UIViewController {
    
    private let contentView = EnterView()
    private let presentationAssembly: IPresentationAssembly
    private let userInfoService: ISensentiveInfoService
    private let networkService: INetworkService
    
    init(
        presentationAssembly: IPresentationAssembly,
        userInfoService: ISensentiveInfoService,
        networkService: INetworkService
    ) {
        self.presentationAssembly = presentationAssembly
        self.userInfoService = userInfoService
        self.networkService = networkService
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupView() {
        contentView.signInHandler = {
            let provider = ASAuthorizationAppleIDProvider()
            let request = provider.createRequest()
            request.requestedScopes = [.email]

            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.presentationContextProvider = self
            controller.performRequests()
        }
    }
    
    private func makeAppleAuth(code: String) {
        networkService.makeAuth(code: code) { [weak self] result in
            DispatchQueue.main.async {
                guard let strongSelf = self else { return }
                switch result {
                case .success(let authModel):
                    guard authModel.accessToken.count > 3 else { return }
                    strongSelf.userInfoService.saveAppleToken(token: authModel.accessToken)
                    strongSelf.makeAuth(token: authModel.accessToken)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func makeAuth(token: String) {
        networkService.makeAuth(token: token) { [weak self] result in
            DispatchQueue.main.async {
                guard let strongSelf = self else { return }
                switch result {
                case .success(let token):
                    guard token.count > 3 else { return }
                    strongSelf.userInfoService.saveToken(token: token) { _ in
                        strongSelf.goToTabbar()
                    }
                case .failure(let failure):
                    print(failure.localizedDescription)
                }
            }
        }
    }
    
    private func goToTabbar() {
        let viewController = presentationAssembly.tabbarController()
        if #available(iOS 13.0, *) {
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(viewController)
        } else {
            (UIApplication.shared.delegate as? AppDelegate)?.changeRootViewController(viewController)
        }
    }

}

extension EnterViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("failed")
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let credentiontials as ASAuthorizationAppleIDCredential:
            guard
                let code = credentiontials.authorizationCode,
                let codeString = String(data: code, encoding: .utf8)
            else { return }
            print("code: \(codeString)")
            makeAppleAuth(code: codeString)
        default:
            break
        }
    }
}

extension EnterViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        view.window!
    }
}
