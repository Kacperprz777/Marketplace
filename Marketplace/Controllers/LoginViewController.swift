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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureWelcomeView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    private func configureWelcomeView() {
        view.addSubview(welcomeView)
        
        welcomeView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        
    }


}

