//
//  ForgotPasswordView.swift
//  Marketplace
//
//  Created by Paweł Przybyła on 27/08/2022.
//

import UIKit
import SnapKit

class ForgotPasswordView: UIView {

    private let appTitleImage = UIImageView()
    private let resetPasswordLabel = UILabel()
    private let emailTextField = BindingTextField(placeholderText: Constants.email)
    private let sendNewPasswordButton = UIButton.makeButton(title: Constants.sendNewPassword)
    
    private(set) var viewModel: ForgotPasswordViewModel
    
    init(viewModel: ForgotPasswordViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        configureAppTitleImage()
        configureResetPasswordLabel()
        configureEmailTextField()
        configureSendNewPasswordButton()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureAppTitleImage() {
        appTitleImage.image = Images.titleImage
        addSubview(appTitleImage)
        
        appTitleImage.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(25)
            make.height.equalTo(60)
            make.leading.equalTo(safeAreaLayoutGuide).offset(25)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-25)
        }
        
    }
    
    private func configureResetPasswordLabel() {
        resetPasswordLabel.text = Constants.resetPassword
        resetPasswordLabel.font = UIFont.systemFont(ofSize: 22)
        resetPasswordLabel.textAlignment = .center
        resetPasswordLabel.textColor = .black
        
        addSubview(resetPasswordLabel)
        
        resetPasswordLabel.snp.makeConstraints { make in
            make.top.equalTo(appTitleImage.snp.bottom).offset(12)
            make.leading.trailing.equalTo(appTitleImage)
            make.height.equalTo(20)
        }
    }
    
    private func configureEmailTextField() {
        addSubview(emailTextField)
        
        emailTextField.bind { [weak self] text in
            self?.viewModel.setEmail(text)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(resetPasswordLabel.snp.bottom).offset(25)
            make.trailing.leading.equalTo(resetPasswordLabel)
            make.height.equalTo(20)
        }
    }
    
    private func configureSendNewPasswordButton() {
        sendNewPasswordButton.addTarget(self, action: #selector(sendNewPasswordButtonTapped), for: .touchUpInside)
        addSubview(sendNewPasswordButton)
        
        sendNewPasswordButton.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
            make.leading.equalTo(emailTextField).offset(25)
            make.trailing.equalTo(emailTextField).offset(-25)
            make.height.equalTo(35)
        }
        
    }
    
    @objc private func sendNewPasswordButtonTapped() {
        viewModel.resetPassword()
    }
    
    
}
