//
//  UIViewController+Alerts.swift
//  Marketplace
//
//  Created by Paweł Przybyła on 05/09/2022.
//

import UIKit

extension UIViewController {
    public func showAlert(title: String?, message: String?, handler: ((UIAlertAction) -> Void)? = nil) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: handler)
    alertController.addAction(okAction)
    present(alertController, animated: true)
  }
}
