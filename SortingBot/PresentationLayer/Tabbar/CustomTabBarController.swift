//
//  CustomTabBarController.swift
//  SortingBot
//
//  Created by Дмитрий Терехин on 27.12.2022.
//

import UIKit

class CustomTabBarController: UITabBarController, CustomTabBarDelegate {
    
    static var tabbarBottomDistance: CGFloat {
        let screenLongestSide: CGFloat = max(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
        // 736 < SE,6,7,8
        return screenLongestSide < 736 ? 15 : CGFloat(59).dp
    }
    static let tabbarHeight: CGFloat = CGFloat(70).dp
    
    private let customTabBar: CustomTabBar
    
    init(tabBar: CustomTabBar) {
        self.customTabBar = tabBar
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupLayout()
        setupProperties()
        bind()
        view.layoutIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupHierarchy() {
        view.addSubview(customTabBar)
        customTabBar.clipsToBounds = true
    }
    
    private func setupLayout() {
        customTabBar.bottomAnchor.constraint(equalTo: customTabBar.superview!.bottomAnchor, constant: -CustomTabBarController.tabbarBottomDistance).isActive = true
        customTabBar.centerXAnchor.constraint(equalTo: customTabBar.superview!.centerXAnchor).isActive = true
        customTabBar.heightAnchor.constraint(equalToConstant: CustomTabBarController.tabbarHeight).isActive = true
        customTabBar.leftAnchor.constraint(equalTo: customTabBar.superview!.leftAnchor, constant: 2).isActive = true
        customTabBar.rightAnchor.constraint(equalTo: customTabBar.superview!.rightAnchor, constant: -2).isActive = true
        customTabBar.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupProperties() {
        tabBar.isHidden = true
        selectedIndex = 0
        setViewControllers(customTabBar.allViewControllers, animated: true)
    }
    
    private func selectTabWith(index: Int) {
        selectedIndex = index
    }
    
    private func bind() {
        customTabBar.delegate = self
    }
    
    // MARK: - Delegate
    func itemWasTapped(with index: Int) {
        self.selectTabWith(index: index)
    }
    
    func showScreen(_ type: CustomTabItemType) {
        guard let index = customTabBar.getIndexFor(type: type) else { return }
        customTabBar.selectItem(index: index)
    }

}

// HidingTabar
extension CustomTabBarController {

    /**
     Show or hide the tab bar.
     - Parameter hidden: `true` if the bar should be hidden.
     - Parameter animated: `true` if the action should be animated.
     - Parameter transitionCoordinator: An optional `UIViewControllerTransitionCoordinator` to perform the animation
        along side with. For example during a push on a `UINavigationController`.
     */
    func setTabBar(
        hidden: Bool,
        animated: Bool = true,
        along transitionCoordinator: UIViewControllerTransitionCoordinator? = nil
    ) {
        guard isTabBarHidden != hidden else { return }

        let offsetY = hidden ? (customTabBar.frame.height + CustomTabBarController.tabbarBottomDistance) : -(customTabBar.frame.height + CustomTabBarController.tabbarBottomDistance)
        let endFrame = customTabBar.frame.offsetBy(dx: 0, dy: offsetY)
        let vc: UIViewController? = viewControllers?[selectedIndex]
        var newInsets: UIEdgeInsets? = vc?.additionalSafeAreaInsets
        let originalInsets = newInsets
        newInsets?.bottom -= offsetY

        /// Helper method for updating child view controller's safe area insets.
        func set(childViewController cvc: UIViewController?, additionalSafeArea: UIEdgeInsets) {
            cvc?.additionalSafeAreaInsets = additionalSafeArea
            cvc?.view.setNeedsLayout()
        }

        // Update safe area insets for the current view controller before the animation takes place when hiding the bar.
        if hidden, let insets = newInsets { set(childViewController: vc, additionalSafeArea: insets) }

        guard animated else {
            customTabBar.frame = endFrame
            return
        }

        // Perform animation with coordinato if one is given. Update safe area insets _after_ the animation is complete,
        // if we're showing the tab bar.
        weak var tabBarRef = self.customTabBar
        if let tc = transitionCoordinator {
            tc.animateAlongsideTransition(in: self.view, animation: { _ in tabBarRef?.frame = endFrame }) { context in
                if !hidden, let insets = context.isCancelled ? originalInsets : newInsets {
                    set(childViewController: vc, additionalSafeArea: insets)
                }
            }
        } else {
            UIView.animate(withDuration: 0.3, animations: { tabBarRef?.frame = endFrame }) { didFinish in
                if !hidden, didFinish, let insets = newInsets {
                    set(childViewController: vc, additionalSafeArea: insets)
                }
            }
        }
    }

    /// `true` if the tab bar is currently hidden.
    var isTabBarHidden: Bool {
        return !customTabBar.frame.intersects(view.frame)
    }

}
