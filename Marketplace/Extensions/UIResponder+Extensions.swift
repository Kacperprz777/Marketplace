//
//  UIResponder+Extensions.swift
//  Marketplace
//
//  Created by Paweł Przybyła on 08/09/2022.
//

import UIKit

extension UIResponder {
    @objc func showAlert(message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        self.next?.showAlert(message: message, handler: handler)
    }
    
    @objc func signOut() {
        self.next?.signOut()
    }
    
    @objc func resetWindow(message: String) {
        self.next?.resetWindow(message: message)
    }
}
