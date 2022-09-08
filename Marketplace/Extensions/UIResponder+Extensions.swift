//
//  UIResponder+Extensions.swift
//  Marketplace
//
//  Created by Paweł Przybyła on 08/09/2022.
//

import UIKit

extension UIResponder {
    @objc func showAlert(message: String) {
        self.next?.showAlert(message: message)
    }
}
