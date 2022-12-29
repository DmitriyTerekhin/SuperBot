//
//  LoaderViewController.swift
//  SortingBot
//
//  Created by Дмитрий Терехин on 27.12.2022.
//

import UIKit
import NVActivityIndicatorView

class LoaderViewController: UIViewController {
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        view.alpha = 0
        return view
    }()
    
    private let label: UILabel = {
        let lbl = UILabel()
        lbl.text = "Please\nwait"
        lbl.numberOfLines = 2
        lbl.textAlignment = .center
        lbl.alpha = 0
        lbl.setFont(fontName: .RobotoMedium, sizeXS: 30)
        return lbl
    }()
    
    private let loaderView: NVActivityIndicatorView = {
        let size = adapted(dimensionSize: 100, to: .height)
        let v = NVActivityIndicatorView(frame: CGRect(x: 0,
                                                      y: 0,
                                                      width: size,
                                                      height: size
                                                     ),
                                        type: NVActivityIndicatorType.circleStrokeSpin)
        v.color = UIColor.white
        v.layer.zPosition = 100
        return v
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.3,
                       animations: {
            self.backgroundView.alpha = 1
            self.label.alpha = 1
        }) { _ in
            self.loaderView.startAnimating()
        }
    }
    
    func hideLoader() {
        UIView.animate(withDuration: 0.3,
                       animations: {
            self.backgroundView.alpha = 0
            self.label.alpha = 0
        }) { _ in
            self.loaderView.stopAnimating()
            self.dismiss(animated: false)
        }
    }
    
    private func setupView() {
        view.isOpaque = false
        view.backgroundColor = .clear
        
        view.addSubview(backgroundView)
        backgroundView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        backgroundView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(loaderView)
        loaderView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loaderView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        loaderView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        loaderView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        loaderView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: loaderView.topAnchor, constant: -55).isActive = true
        label.translatesAutoresizingMaskIntoConstraints = false
    }

}
