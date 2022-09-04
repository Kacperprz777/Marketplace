//
//  FirebaseManager.swift
//  Marketplace
//
//  Created by Paweł Przybyła on 04/09/2022.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

final class FirebaseManager {
    
    // MARK: Firebase Authentication

    
    func createNewUser(email: String, password: String, completion: @escaping (Result<Bool, Error>) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authDataResult, error in
            if let error = error {
                completion(.failure(error))
            } else {
                guard let user =  Auth.auth().currentUser else { return }
                user.sendEmailVerification() { error in
                    guard let error = error else { return }
                    print(error.localizedDescription)
                }
                completion(.success(true))
                
                guard let authDataResult = authDataResult else { return }
                // zapisać do database
                self?.createDatabaseUser(authDataResult: authDataResult) { result in
                    switch result {
                    case .failure(let createDatabaseUserError):
                        print(createDatabaseUserError)
                    case .success(_):
                        break
                    }
                }
            }
        }
    }
    
    func signExistingUser(email: String, password: String, completion: @escaping (Result<Bool, Error>) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(error))
            } else {
                guard let user = Auth.auth().currentUser else { return }
                completion(.success(user.isEmailVerified))
            }
        }
    }
    
    func resetUserPassword(with email: String, completion: @escaping (Result<Void, Error>) -> ()) {
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    // MARK: Firebase Firestore
    
    static let itemsCollection = "items"
    static let usersCollection = "users"
    
    private let db = Firestore.firestore()
    
    func createDatabaseUser(authDataResult: AuthDataResult , completion: @escaping (Result<Bool, Error>) -> ()) {
        guard let email = authDataResult.user.email else { return }
        db.collection(FirebaseManager.usersCollection)
            .document(authDataResult.user.uid)
            .setData(["email" : email,
                      "createDate": Timestamp(date: Date()),
                      "userId": authDataResult.user.uid]) { error in
                
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(true))
                }
                
            }
    }
    

    
    // MARK: Firebase Storage


    
    
    
    
    
    
    
}
