//
//  ViewController.swift
//  Marketplace
//
//  Created by Paweł Przybyła on 18/08/2022.
//

import UIKit
import SnapKit

class LoginViewController: UIViewController {

    private let firebaseManager = FirebaseManager()
    
    private let welcomeView = WelcomeView()
    lazy private var loginScreenView = LoginScreenView(viewModel: viewModel)
    
    lazy private var viewModel = LoginScreenViewModel(firebaseManager: firebaseManager)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureWelcomeView()
        configureLoginScreenView()
    }
    
    override func loadView() {
        view = loginScreenView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        
        viewModel.resetWindowCallback = { [weak self] in
            self?.resetWindow(with: MarketplaceTabBarController())
        }
    }
    
    private func configureVC() {
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .systemBackground
    }
    
    private func configureLoginScreenView() {
        loginScreenView.present = self
        loginScreenView.delegate = self
    }
    
    private func configureWelcomeView() {
        view.addSubview(welcomeView)
        
        welcomeView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }

}

extension LoginViewController: LoginScreenPresentForgotPasswordVC {
    func forgotPasswordVC() {
        let forgotPasswordVC = UINavigationController(rootViewController: ForgotPasswordViewController())
        present(forgotPasswordVC, animated: true)
    }
}

extension LoginViewController: LoginScreenViewDelegate {
    
    func createUserSuccess(message: String) {
        showAlert(title: nil , message: message)
    }
    
    func loginSuccess(message: String) {
        showAlert(title: nil, message: message) { [weak self] _ in
            self?.resetWindow(with: MarketplaceTabBarController())
        }
    }
    
    func loginFailure(message: String) {
        showAlert(title: nil, message: message)
    }
    
    func emailNotVerified(message: String) {
        showAlert(title: nil, message: message)
    }
    
    func createUserFailure(message: String) {
        showAlert(title: nil, message: message)
    }
    
    func passwordsDontMatch(message: String) {
        showAlert(title: nil, message: message)
    }
    func missingFields(message: String) {
        showAlert(title: nil, message: message)
    }
}
