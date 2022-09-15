//
//  MarketplaceCustomTextField.swift
//  Marketplace
//
//  Created by Paweł Przybyła on 01/09/2022.
//

import UIKit

class BindingTextField: UITextField {
    
    private var padding = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    var textChanged: (String) -> Void = { _ in }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(placeholderText: String, padding: UIEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8), isPassword: Bool = false, autocapitalization: UITextAutocapitalizationType = .none  ) {
        self.init(frame: .zero)
        self.padding = padding
        placeholder = placeholderText
        isSecureTextEntry = isPassword
        autocapitalizationType = autocapitalization
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 10
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    private func commonInit() {
        addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        let textFieldFontSize: CGFloat = 18
        backgroundColor = .systemBackground
        font = UIFont.systemFont(ofSize: textFieldFontSize)
        adjustsFontSizeToFitWidth = false
        autocorrectionType = .no
    }
    
    func bind(callback: @escaping (String) -> Void) {
        textChanged = callback
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text {
            textChanged(text)
        }
    }
    
}
