//
//  LoginScreenView.swift
//  Marketplace
//
//  Created by Paweł Przybyła on 24/08/2022.
//

import UIKit

class LoginScreenView: UIView {

    private let logoImage = UIImageView(image: UIImage(named: "logo-Marketplace"))
    private let stackViewLoginInput = UIStackView()
    private let mainButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        return button
    }()
    
    private let forgotPasswordButton: UIButton = {
        let button = UIButton()
        button.setTitle("Forgot your password?", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return button
    }()
    
    private let scrollView = UIScrollView()
    
    private let userNameTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .systemOrange
        textField.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [
            .foregroundColor: UIColor.lightGray
        ])
        return textField
    }()
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .systemOrange
        textField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [
            .foregroundColor: UIColor.lightGray
        ])
        textField.autocapitalizationType = .none
        return textField
    }()
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .systemOrange
        textField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [
            .foregroundColor: UIColor.lightGray
        ])
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let repeatPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .systemOrange
        textField.attributedPlaceholder = NSAttributedString(string: "Repeat password", attributes: [
            .foregroundColor: UIColor.lightGray
        ])
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private var segmentedControl = UISegmentedControl()
    
    init() {
        super.init(frame: .zero)
        configureScrollView()
        configureLogoImage()
        configureSegmentedControl()
        configureStackViewLoginInput()
        configureMainButton()
        configureForgotPasswordButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureLogoImage() {
        scrollView.addSubview(logoImage)
        logoImage.contentMode = .scaleAspectFill
        
        logoImage.snp.makeConstraints { make in
            make.height.equalTo(self).multipliedBy(0.3)
            make.width.equalTo(self).multipliedBy(0.4)
            make.top.equalTo(scrollView.snp_top).offset(10)
            make.centerX.equalTo(scrollView.snp_centerX)
        }
    }
    
    func configureScrollView() {
        self.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.trailing.bottom.leading.equalTo(self)
        }
    }
    
    func configureSegmentedControl() {
        segmentedControl = UISegmentedControl(items: ["Sign In", "Register"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentedControlDidChange), for: .valueChanged)
        scrollView.addSubview(segmentedControl)
        
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(logoImage.snp_bottom).offset(15)
            make.leading.trailing.equalTo(scrollView).offset(55)
            make.centerX.equalTo(logoImage.snp_centerX)
            make.height.equalTo(25)
        }
    }
    
    @objc func segmentedControlDidChange(sender: UISegmentedControl) {
        
        userNameTextField.isHidden = false
        repeatPasswordTextField.isHidden = false
    }
    
    private func configureStackViewLoginInput() {
        userNameTextField.isHidden = true
        repeatPasswordTextField.isHidden = true
        
        stackViewLoginInput.addArrangedSubview(userNameTextField)
        stackViewLoginInput.addArrangedSubview(emailTextField)
        stackViewLoginInput.addArrangedSubview(passwordTextField)
        stackViewLoginInput.addArrangedSubview(repeatPasswordTextField)
        stackViewLoginInput.axis = .vertical
        stackViewLoginInput.distribution = .equalSpacing
        stackViewLoginInput.spacing = 20
        
        scrollView.addSubview(stackViewLoginInput)
        
        stackViewLoginInput.snp.makeConstraints { make in
            make.leading.trailing.equalTo(segmentedControl)
            make.top.equalTo(segmentedControl.snp_bottom).offset(15)
        }
    }
    
    private func configureMainButton() {
        
        mainButton.addTarget(self, action: #selector(mainButtonTapped), for: .touchUpInside)
        scrollView.addSubview(mainButton)
        
        mainButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(stackViewLoginInput)
            make.top.equalTo(stackViewLoginInput.snp_bottom).offset(20)
            make.height.equalTo(35)
        }
    }
    
    @objc private func mainButtonTapped() {
        print("mainButtonTapped")
    }
    
    private func configureForgotPasswordButton() {
        addSubview(forgotPasswordButton)
        forgotPasswordButton.addTarget(self, action: #selector(forgotPasswordButtonTapped), for: .touchUpInside)
        
        forgotPasswordButton.snp.makeConstraints { make in
            make.trailing.leading.equalTo(self)
            make.height.equalTo(15)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-8)
        }
        
    }
    
    @objc private func forgotPasswordButtonTapped() {
        print("forgotPasswordButtonTapped")
    }
    
    
    
    
    
}
