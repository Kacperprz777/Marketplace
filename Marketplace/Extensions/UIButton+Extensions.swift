//
//  UIButton+Extensions.swift
//  Marketplace
//
//  Created by Paweł Przybyła on 01/09/2022.
//

import UIKit

extension UIButton {
    
    static func makeButton(title: String) -> UIButton {
        let button = UIButton()
        button.setTitle("\(title)", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        return button
    }
    
    static func makeforgotPasswordButton() -> UIButton {
        let button = UIButton()
        button.setTitle("Forgot your password?", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return button
    }
    
    static func makeSignOutButton() -> UIButton {
        let button = UIButton()
        button.setTitle("Sign Out", for: .normal)
        button.backgroundColor = .systemRed
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 10
        return button
    }
    
    static func makeEditPhotoButton() -> UIButton {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold, scale: .large)
        let boldPencil = UIImage(systemName: "pencil.circle.fill", withConfiguration: config)

        button.setImage(boldPencil, for: .normal)
        return button
    }
}
