//
//  ForgotPasswordViewController.swift
//  Marketplace
//
//  Created by Paweł Przybyła on 27/08/2022.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    private let forgotPasswordView = ForgotPasswordView()
    
    override func loadView() {
        view = forgotPasswordView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureNavigationBar()
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
