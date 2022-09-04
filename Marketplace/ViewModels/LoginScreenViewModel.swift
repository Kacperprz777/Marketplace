//
//  LoginScreenViewModel.swift
//  Marketplace
//
//  Created by Paweł Przybyła on 26/08/2022.
//

import Foundation

final class LoginScreenViewModel {
    
    enum ViewState {
        case signIn
        case register
    }
    
    var resetWindowCallback: () -> () = { }
    
    private(set) var state: ViewState = .signIn
    
    var isInSignInState: Bool {
        if case .signIn = state {
             return true
        } else {
            return false
        }
    }
    
     func toogleState() {
        state = state == .signIn ? .register : .signIn
    }
    
    func setTitleForMainButton() -> String {
        if isInSignInState {
            return "Sign In"
        } else {
            return "Register"
        }
    }
    
    func mainButtonTapped() {
        resetWindowCallback()
    }
    
    
    
    
    
    
    
    
    
    
    
}
