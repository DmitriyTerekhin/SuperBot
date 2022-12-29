//
//  WebViewViewController.swift
//  SortingBot
//
//  Created by Дмитрий Терехин on 26.12.2022.
//

import UIKit
import WebKit
import NVActivityIndicatorView

class WebViewViewController: UIViewController {
    
    private let webView: WKWebView = WKWebView()
    private let site: String
    private let navigationTitle: String?
    
    private let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .AppCollors.backgroundBlue
        return view
    }()
    private let loaderBackgroundView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.dropShadow()
        return view
    }()
    
    private let loaderView: NVActivityIndicatorView = {
        let v = NVActivityIndicatorView(frame: CGRect(x: 0,
                                                      y: 0,
                                                      width: CGFloat(40).dp,
                                                      height: CGFloat(40).dp),
                                        type: NVActivityIndicatorType.circleStrokeSpin)
        v.color = UIColor.AppCollors.backgroundBlue
        v.layer.zPosition = 100
        return v
    }()
    
    init(site: String, title: String?) {
        self.site = site
        self.navigationTitle = title
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = navigationTitle
        setupView()
        startLoading()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
//        (tabBarController as? CustomTabBarController)?.setTabBar(hidden: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
//        (tabBarController as? CustomTabBarController)?.setTabBar(hidden: false)
    }
    
    private func setupView() {
        view.backgroundColor = .white
        navigationController?.navigationBar.barTintColor = UIColor.AppCollors.backgroundBlue
        webView.navigationDelegate = self
        view.addSubview(webView)
        view.addSubview(bottomView)
        webView.addSubview(loaderView)
        webView.addSubview(loaderBackgroundView)

        webViewConstraints()
        loaderBackgroundViewConstraints()
        laoderViewConstraints()
        addGoBackButton()
    }
    
    @objc
    private func addGoBackButton() {
        if webView.canGoBack{
            let button = UIButton(type: .system)
            button.setImage(UIImage(named: "ArrowLeft")?.withRenderingMode(.alwaysOriginal), for: .normal)
            button.setTitle("Back", for: .normal)
            button.sizeToFit()
            button.tintColor = .AppCollors.backgroundBlue
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
            button.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        } else {
            navigationItem.leftBarButtonItem = nil
        }
    }
    
    @objc
    private func goBack() {
        if webView.canGoBack {
            webView.goBack()
        }
    }
    
    private func webViewConstraints() {
        webView.topAnchor.constraint(equalTo: webView.superview!.safeTopAnchor).isActive = true
        webView.rightAnchor.constraint(equalTo: webView.superview!.rightAnchor).isActive = true
        webView.leftAnchor.constraint(equalTo: webView.superview!.leftAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: webView.superview!.bottomAnchor, constant: -25).isActive = true
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        bottomView.topAnchor.constraint(equalTo: webView.bottomAnchor).isActive = true
        bottomView.bottomAnchor.constraint(equalTo: bottomView.superview!.bottomAnchor).isActive = true
        bottomView.leftAnchor.constraint(equalTo: bottomView.superview!.leftAnchor).isActive = true
        bottomView.rightAnchor.constraint(equalTo: bottomView.superview!.rightAnchor).isActive = true
        bottomView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func loaderBackgroundViewConstraints() {
        loaderBackgroundView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        loaderBackgroundView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        loaderBackgroundView.centerXAnchor.constraint(equalTo: loaderBackgroundView.superview!.centerXAnchor).isActive = true
        loaderBackgroundView.centerYAnchor.constraint(equalTo: loaderBackgroundView.superview!.centerYAnchor).isActive = true
        loaderBackgroundView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func laoderViewConstraints() {
        loaderView.centerYAnchor.constraint(equalTo: loaderView.superview!.centerYAnchor).isActive = true
        loaderView.centerXAnchor.constraint(equalTo: loaderView.superview!.centerXAnchor).isActive = true
        loaderView.widthAnchor.constraint(equalToConstant: CGFloat(35).dp).isActive = true
        loaderView.heightAnchor.constraint(equalToConstant: CGFloat(35).dp).isActive = true
        loaderView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func startLoading() {
        guard let url = URL(string: site) else {return}
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    private func showLoader(toggle: Bool) {
        if toggle {
            loaderView.startAnimating()
            loaderBackgroundView.isHidden = false
        } else {
            loaderView.stopAnimating()
            loaderBackgroundView.isHidden = true
        }
    }
}

//MARK: - WKWebView
extension WebViewViewController: WKNavigationDelegate, WKUIDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        showLoader(toggle: true)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        showLoader(toggle: false)
        addGoBackButton()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        showLoader(toggle: false)
        addGoBackButton()
    }
}
