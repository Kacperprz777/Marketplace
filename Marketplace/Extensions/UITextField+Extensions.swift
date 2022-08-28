//
//  UITextField+Extensions.swift
//  Marketplace
//
//  Created by Paweł Przybyła on 26/08/2022.
//

import UIKit

extension UITextField {
    
    static func makeLoginScreenViewTextfield(placeholder: String, isPassword: Bool) -> UITextField {
            let textField = UITextField()
            textField.textColor = .systemOrange
            textField.isSecureTextEntry = isPassword
            textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [
                .foregroundColor: UIColor.lightGray
            ])
            return textField
    }
    
    static func makeTextfield(placeholder: String) -> UITextField {
            let textField = UITextField()
            textField.textColor = .black
            textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [
                .foregroundColor: UIColor.lightGray
            ])
            return textField
    }
}
