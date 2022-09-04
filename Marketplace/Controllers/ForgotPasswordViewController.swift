//
//  ForgotPasswordViewController.swift
//  Marketplace
//
//  Created by Paweł Przybyła on 27/08/2022.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    
    var viewModel = ForgotPasswordViewModel()
    lazy private(set) var forgotPasswordView = ForgotPasswordView(viewModel: viewModel)
    
    override func loadView() {
        view = forgotPasswordView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureNavigationBar()
        
        viewModel.onSendNewPasswordButtonTapped = { [weak self] in
            print("password has been reset")
            self?.dismiss(animated: true)
            
        }
        
        
    }
    
    private func configureVC() {
        view.backgroundColor = .systemBackground
    }
    
    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }

}
