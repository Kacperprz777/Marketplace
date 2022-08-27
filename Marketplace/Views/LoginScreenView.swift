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
    private let viewModel: LoginScreenViewModel

    
    private let mainButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign In", for: .normal)
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
    
    private(set) var userNameTextField = UITextField.makeLoginScreenViewTextfield(placeholder: "Name", isPassword: false)
    private(set) var emailTextField = UITextField.makeLoginScreenViewTextfield(placeholder: "Email", isPassword: false)
    private(set) var passwordTextField = UITextField.makeLoginScreenViewTextfield(placeholder: "Password", isPassword: true)
    private(set) var repeatPasswordTextField = UITextField.makeLoginScreenViewTextfield(placeholder: "Repeat password", isPassword: true)
    
    private var segmentedControl = UISegmentedControl()
    
    init(viewModel: LoginScreenViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        configureScrollView()
        configureLogoImage()
        configureSegmentedControl()
        configureStackViewLoginInput()
        configureMainButton()
        configureForgotPasswordButton()
        configureTapGesture()
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
            make.height.equalTo(30)
        }
    }
    
    @objc func segmentedControlDidChange(sender: UISegmentedControl) {
        viewModel.toogleState()
        
        userNameTextField.isHidden = viewModel.isInSignInState
        repeatPasswordTextField.isHidden = viewModel.isInSignInState
        mainButton.setTitle(viewModel.setTitleForMainButton(), for: .normal)
        
    }
    
    private func configureStackViewLoginInput() {
        userNameTextField.isHidden = true
        repeatPasswordTextField.isHidden = true
        userNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        repeatPasswordTextField.delegate = self
        
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
            make.height.equalTo(45)
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
    
    private func configureTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(UIView.endEditing))
        addGestureRecognizer(tapGesture)
    }
    
}


extension LoginScreenView: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 175), animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//
//    }
}
