//
//  ForgotPasswordViewModel.swift
//  Marketplace
//
//  Created by Paweł Przybyła on 27/08/2022.
//

import Foundation

final class ForgotPasswordViewModel {
    
    weak var firebaseManager: FirebaseManager?
    private var email = ""
    var error: ObservableObject<String?> = ObservableObject(nil)
    var success: ObservableObject<String?> = ObservableObject(nil)
    
    init(firebaseManager: FirebaseManager) {
        self.firebaseManager = firebaseManager
    }
    
    func setEmail(_ text:String) {
        self.email = text
    }
    
    func resetPassword() {
        if !email.isEmpty{
            firebaseManager?.resetUserPassword(with: email, completion: {[weak self] result in
                switch result {
                case .failure(let error):
                    self?.error.value = error.localizedDescription
                case .success(_):
                    self?.success.value = Constants.passwordReset
                }
            })
        }
        
    }
    
}
