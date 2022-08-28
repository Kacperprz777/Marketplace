//
//  ForgotPasswordViewModel.swift
//  Marketplace
//
//  Created by Paweł Przybyła on 27/08/2022.
//

import Foundation

final class ForgotPasswordViewModel {
    
    var onSendNewPasswordButtonTapped: () -> Void = {}
    
    func resetPassword(withEmail: String) {
        
        onSendNewPasswordButtonTapped()
    }

}
