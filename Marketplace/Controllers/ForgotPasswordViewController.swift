//
//  ForgotPasswordViewController.swift
//  Marketplace
//
//  Created by Paweł Przybyła on 27/08/2022.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    private let firebaseManager = FirebaseManager()
    
    lazy private(set) var viewModel = ForgotPasswordViewModel(firebaseManager: firebaseManager)
    lazy private var forgotPasswordView = ForgotPasswordView(viewModel: viewModel)
    
    override func loadView() {
        view = forgotPasswordView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureNavigationBar()
        setupBinders()
    }
    
    private func setupBinders() {
        viewModel.error.bind { [weak self] error in
            guard let error = error else { return }
                self?.showAlert(title: nil, message: error)
        }
        
        viewModel.success.bind { [weak self] succes in
            guard let succes = succes else { return }
                self?.showAlert(title: nil, message: succes) { _ in
                    self?.dismiss(animated: true)
                }
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
