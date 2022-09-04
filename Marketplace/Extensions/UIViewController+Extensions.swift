//
//  UIViewController+Extensions.swift
//  Marketplace
//
//  Created by Paweł Przybyła on 03/09/2022.
//

import UIKit

extension UIViewController {
    
    func resetWindow(with tabBarController: UITabBarController) {
        guard let scene = UIApplication.shared.connectedScenes.first,
              let sceneDelegate = scene.delegate as? SceneDelegate,
              let window = sceneDelegate.window else {
            fatalError("could not reset window rootViewController")
        }
        window.rootViewController = tabBarController
    }
    
    func resetWindow(with viewController: UIViewController) {
        guard let scene = UIApplication.shared.connectedScenes.first,
              let sceneDelegate = scene.delegate as? SceneDelegate,
              let window = sceneDelegate.window else {
            fatalError("could not reset window rootViewController")
        }
        window.rootViewController = viewController
    }
}
