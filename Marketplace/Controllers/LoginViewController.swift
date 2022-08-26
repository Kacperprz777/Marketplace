//
//  ViewController.swift
//  Marketplace
//
//  Created by Paweł Przybyła on 18/08/2022.
//

import UIKit
import SnapKit

class LoginViewController: UIViewController {

    private let welcomeView = WelcomeView()
    private let loginScreenView = LoginScreenView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureWelcomeView()
    }
    
    override func loadView() {
        view = loginScreenView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
    }
    
    private func configureVC() {
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .systemBackground
    }
    
    private func configureWelcomeView() {
        view.addSubview(welcomeView)
        
        welcomeView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }

}

