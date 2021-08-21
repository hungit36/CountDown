//
//  UIViewController.swift
//  CountTime
//
//  Created by Hưng Nguyễn on 8/21/21.
//  Email: hungnguyen.it36@gmail.com
//

import UIKit

extension UIViewController {
    @discardableResult func showAlert(title: String?, message: String?, buttonTitles: [String]? = nil, highlightedButtonIndex: Int? = nil, completion: ((Int) -> Void)? = nil) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        var allButtons = buttonTitles ?? [String]()
        if allButtons.isEmpty {
            allButtons.append("OK")
        }

        for index in 0..<allButtons.count {
            let buttonTitle = allButtons[index]
            let action = UIAlertAction(title: buttonTitle, style: .default, handler: { (_) in
                completion?(index)
            })
            alertController.addAction(action)
            // Check which button to highlight
            if let highlightedButtonIndex = highlightedButtonIndex, index == highlightedButtonIndex {
                if #available(iOS 9.0, *) {
                    alertController.preferredAction = action
                }
            }
        }
        present(alertController, animated: true, completion: nil)
        return alertController
    }
    
    class func instantiate(storyboard: String? = nil, identifier: String? = nil) -> Self
    {
        return _instantiate(storyboard: storyboard, identifier: identifier)
    }
    
    fileprivate class func _instantiate<T: UIViewController>(storyboard: String?, identifier: String?) -> T {
        let storyboard1 = (storyboard != nil) ? storyboard! : String(describing: self)
        let identifier1 = (identifier != nil) ? identifier! : String(describing: self)
        let storyboard2 = UIStoryboard(name: storyboard1, bundle: nil)
        let controller = storyboard2.instantiateViewController(withIdentifier: identifier1) as! T
        return controller
    }
}
