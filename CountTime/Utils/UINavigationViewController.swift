//
//  UINavigationViewController.swift
//  CountTime
//
//  Created by tps on 8/21/21.
//

import UIKit

extension UINavigationController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
    
    func setBackgroundColor(color: UIColor = .white) {
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.backgroundColor = color
    }
    
    func transparentBackground() {
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.backgroundColor = .clear
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.layoutIfNeeded()
    }
}

extension UINavigationController {
    func getViewController<T: UIViewController>(of type: T.Type) -> UIViewController? {
        return self.viewControllers.first(where: { $0 is T })
    }

    func popToViewController<T: UIViewController>(of type: T.Type, animated: Bool) {
        guard let viewController = self.getViewController(of: type) else { return }
        self.popToViewController(viewController, animated: animated)
    }
}

extension UINavigationController {

    private func containsViewController(ofKind kind: AnyClass) -> Bool {
        return self.viewControllers.contains(where: { $0.isKind(of: kind) })
    }

    func pop(ofKind kind: AnyClass) {
        if containsViewController(ofKind: kind) {
            for controller in self.viewControllers {
                if controller.isKind(of: kind) {
                    popToViewController(controller, animated: true)
                    break
                }
            }
        }
    }
}
