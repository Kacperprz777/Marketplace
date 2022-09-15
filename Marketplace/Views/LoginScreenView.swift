//
//  LoginScreenView.swift
//  Marketplace
//
//  Created by Paweł Przybyła on 24/08/2022.
//

import UIKit

protocol LoginScreenPresentForgotPasswordVC: AnyObject {
    func forgotPasswordVC()
}

class LoginScreenView: UIView {
    
    private let logoImage = UIImageView(image: UIImage(named: "logo-Marketplace"))
    private let stackViewLoginInput = UIStackView()
    private let viewModel: LoginScreenViewModel
    private let mainButton = UIButton.makeButton(title: "Sign In")
    private let forgotPasswordButton = UIButton.makeforgotPasswordButton()
    
    private let scrollView = UIScrollView()
    
    private(set) var userNameTextField = BindingTextField(placeholderText: "Name", autocapitalization: .words)
    private(set) var emailTextField = BindingTextField(placeholderText: "Email")
    private(set) var passwordTextField = BindingTextField(placeholderText: "Password", isPassword: true)
    private(set) var repeatPasswordTextField = BindingTextField(placeholderText: "Repeat password", isPassword: true)
    
    private var segmentedControl = UISegmentedControl()
    
    weak var present: LoginScreenPresentForgotPasswordVC?
    
    init(viewModel: LoginScreenViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        viewModel.loginEvents = self
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
            make.top.equalTo(scrollView.snp.top).offset(10)
            make.centerX.equalTo(scrollView.snp.centerX)
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
            make.top.equalTo(logoImage.snp.bottom).offset(15)
            make.leading.trailing.equalTo(scrollView).offset(55)
            make.centerX.equalTo(logoImage.snp.centerX)
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
        
        userNameTextField.bind { [weak self] text in
            self?.viewModel.setUserName(text)
        }
        
        emailTextField.bind { [weak self] text in
            self?.viewModel.setEmail(text)
        }
        
        passwordTextField.bind { [weak self] text in
            self?.viewModel.setPassword(text)
        }
        
        repeatPasswordTextField.bind { [weak self] text in
            self?.viewModel.setRepeatPassword(text)
        }
        
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
            make.top.equalTo(segmentedControl.snp.bottom).offset(15)
        }
    }
    
    private func configureMainButton() {
        
        mainButton.addTarget(self, action: #selector(mainButtonTapped), for: .touchUpInside)
        scrollView.addSubview(mainButton)
        
        mainButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(stackViewLoginInput)
            make.top.equalTo(stackViewLoginInput.snp.bottom).offset(20)
            make.height.equalTo(45)
        }
    }
    
    @objc private func mainButtonTapped() {
        viewModel.mainButtonTapped()
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
        present?.forgotPasswordVC()
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
}

extension LoginScreenView: LoginScreenViewEvents {

    func createUserFailure(error: Error) {
        showAlert(message: error.localizedDescription)
    }
    
    func onLoginFailure(error: Error) {
        showAlert(message: error.localizedDescription)
    }
    
    func onLoginSuccess() {
        emailTextField.text = ""
        passwordTextField.text = ""
        endEditing(true)
        resetWindow(message: "Logged in")
    }
    
    func createUserSuccess() {
        showAlert(message: "Check your email with activation link") { [weak self] _ in
            self?.segmentedControl.selectedSegmentIndex = 0
            self?.viewModel.toogleState()
            self?.userNameTextField.isHidden = true
            self?.repeatPasswordTextField.isHidden = true
            self?.userNameTextField.text = ""
            self?.repeatPasswordTextField.text = ""
            self?.mainButton.setTitle("Sign In", for: .normal)
            self?.endEditing(true)
        }
    }
    
    func emailNotVerified() {
        showAlert(message: "Your email is not verified")
    }
    
    func passwordsDontMatch() {
        showAlert(message: "Passwords do not match")
    }
    
    func missingFields() {
        showAlert(message: "All fields are required")
    }
}


