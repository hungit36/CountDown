//
//  UINavigationItem.swift
//  CountTime
//
//  Created by tps on 8/21/21.
//

import UIKit

extension UINavigationItem {
    func setNavigationItem(leftButton: UIButton? = nil, rightButton: UIButton? = nil, title: String? = nil, subTitle: String? = nil,titleColor: UIColor = .black, subTitleColor: UIColor = .gray,withFont: UIFont? = nil){
        self.hidesBackButton = true
        if let leftButton = leftButton {
            self.leftButton(button: leftButton)
        }
        if let rightButton = rightButton {
            self.rightButton(button: rightButton)
        }
        updateTitle(title: title, subTitle: subTitle, titleColor: titleColor, subTitleColor: subTitleColor, withFont: withFont)
    }
    
    func leftButton(button: UIButton) {
        self.hidesBackButton = true
        self.leftBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    func leftArrayButton(buttons: [UIButton]) {
        self.hidesBackButton = true
        var arrayBarItems : [UIBarButtonItem] = []
        for button in buttons {
            arrayBarItems.append(UIBarButtonItem(customView: button))
        }
        self.leftBarButtonItems = arrayBarItems
    }
    
    func rightButton(button: UIButton) {
        self.hidesBackButton = true
        self.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    func rightArrayButton(buttons: [UIButton]) {
        self.hidesBackButton = true
        var arrayBarItems : [UIBarButtonItem] = []
        for button in buttons {
            arrayBarItems.append(UIBarButtonItem(customView: button))
        }
        self.rightBarButtonItems = arrayBarItems
    }
    
    func updateTitle(title: String? = nil, subTitle: String? = nil, titleColor: UIColor = .black, subTitleColor: UIColor = .gray, withFont: UIFont? = nil) {
        if let sub = subTitle {
            self.titleView = setTitle(title: title ?? "", subtitle: sub, titleColor: titleColor, subTitleColor: subTitleColor, withFont: withFont)
        } else {
            let titleLabel = UILabel(frame: CGRect(x: 0, y: -2, width: 0, height: 0))

            titleLabel.backgroundColor = .clear
            titleLabel.textColor = titleColor
            titleLabel.font = withFont != nil ? withFont : UIFont.boldSystemFont(ofSize: 17)
            titleLabel.text = title
            titleLabel.sizeToFit()
            self.titleView = titleLabel
        }
    }
    
    private func setTitle(title: String, subtitle: String, titleColor: UIColor = .black, subTitleColor: UIColor = .gray, withFont: UIFont? = nil) -> UIView {
        let titleLabel = UILabel(frame: CGRect(x: 0, y: -2, width: 0, height: 0))

        titleLabel.backgroundColor = .clear
        titleLabel.textColor = titleColor
        titleLabel.font = withFont != nil ? withFont : UIFont.boldSystemFont(ofSize: 17)
        titleLabel.text = title
        titleLabel.sizeToFit()

        let subtitleLabel = UILabel(frame: CGRect(x: 0, y: 18, width: 0, height: 0))
        subtitleLabel.backgroundColor = .clear
        subtitleLabel.textColor = subTitleColor
        subtitleLabel.font = withFont != nil ? withFont : UIFont.systemFont(ofSize: 12)
        subtitleLabel.text = subtitle
        subtitleLabel.sizeToFit()

        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: max(titleLabel.frame.size.width, subtitleLabel.frame.size.width), height: 30))
        titleView.addSubview(titleLabel)
        titleView.addSubview(subtitleLabel)

        let widthDiff = subtitleLabel.frame.size.width - titleLabel.frame.size.width

        if widthDiff < 0 {
            let newX = widthDiff / 2
            subtitleLabel.frame.origin.x = abs(newX)
        } else {
            let newX = widthDiff / 2
            titleLabel.frame.origin.x = newX
        }

        return titleView
    }
    
    func replaceTitle(with image: UIImage) {
        let logoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.image = image
        titleView = logoImageView
    }
}
