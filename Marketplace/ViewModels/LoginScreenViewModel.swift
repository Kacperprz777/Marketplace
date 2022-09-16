//
//  LoginScreenViewModel.swift
//  Marketplace
//
//  Created by Paweł Przybyła on 26/08/2022.
//

import Foundation

protocol LoginScreenViewEvents: AnyObject {
    func onLoginSuccess()
    func onLoginFailure(error: Error)
    func createUserSuccess()
    func createUserFailure(error: Error)
    func emailNotVerified()
    func passwordsDontMatch()
    func missingFields()
}

final class LoginScreenViewModel {
    
    enum ViewState {
        case signIn
        case register
    }
    
    weak var firebaseManager: FirebaseManager?
    weak var loginEvents: LoginScreenViewEvents?
    
    private var userName = ""
    private var email = ""
    private var password = ""
    private var repeatPassword = ""
    
    var resetWindowCallback: () -> () = { }
    
    private(set) var state: ViewState = .signIn
    
    var isInSignInState: Bool {
        if case .signIn = state {
             return true
        } else {
            return false
        }
    }
    
    init(firebaseManager: FirebaseManager) {
        self.firebaseManager = firebaseManager
    }
    
     func toogleState() {
        state = state == .signIn ? .register : .signIn
    }
    
    func setTitleForMainButton() -> String {
        if isInSignInState {
            return Constants.signIn
        } else {
            return Constants.register
        }
    }
    
    func setUserName(_ userName: String) {
        self.userName = userName
    }
    
    func setEmail(_ email: String) {
        self.email = email
    }
    
    func setPassword(_ password: String) {
        self.password = password
    }
    
    func setRepeatPassword(_ repeatPassword: String) {
        self.repeatPassword = repeatPassword
    }
    
    private func comparePasswords(createPassword: String, confirmPassword: String) -> Bool {
        if createPassword == confirmPassword {
            return true
        } else {
            loginEvents?.passwordsDontMatch()
            return false
        }
    }
    
    func mainButtonTapped() {
        if state == .signIn && !email.isEmpty && !password.isEmpty {
            signInUser()
        } else if state == .register && !userName.isEmpty && !email.isEmpty && !password.isEmpty && comparePasswords(createPassword: password, confirmPassword: repeatPassword) {
            createNewUser()
        } else {
            loginEvents?.missingFields()
        }
    }
    
    func signInUser() {
        firebaseManager?.signExistingUser(email: email, password: password, completion: { [weak self] result in
            switch result {
            case .success(let emailVerified):
                if !emailVerified {
                    self?.loginEvents?.emailNotVerified()
                } else {
                    self?.loginEvents?.onLoginSuccess()
                }
            case .failure(let error):
                self?.loginEvents?.onLoginFailure(error: error)
            }
        })
    }
    
    func createNewUser() {
        firebaseManager?.createNewUser(email: email, password: password, completion: { [weak self] result in
            switch result {
            case .success(_):
                self?.loginEvents?.createUserSuccess()
            case .failure(let error):
                self?.loginEvents?.createUserFailure(error: error)
            }
        })
    }
    

    
    
    
    
    
    
    
}
