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
    
}
