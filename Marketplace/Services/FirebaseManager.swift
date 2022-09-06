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
import UIKit.UIImage

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
    
    func updateDatabaseUser(photoURL: String,
                            completion: @escaping (Result<Bool, Error>) -> ()) {
        
        guard let user = Auth.auth().currentUser else { return }
        db.collection(FirebaseManager.usersCollection)
            .document(user.uid).updateData(["photoURL" : photoURL]) { (error) in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(true))
                }
            }
    }
    
    func createItem(itemName: String,
                    price: Double,
                    category: Category,
                    completion: @escaping (Result<String, Error>) -> ()) {
        guard let user = Auth.auth().currentUser else { return }
        let documentRef = db.collection(FirebaseManager.itemsCollection).document()
        db.collection(FirebaseManager.itemsCollection)
            .document(documentRef.documentID)
            .setData(["itemName":itemName,
                      "price": price,
                      "itemId":documentRef.documentID,
                      "listedDate": Timestamp(date: Date()),
                      "sellerId": user.uid,
                      "categoryName": category.name]) { (error) in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(documentRef.documentID))
                }
            }
    }
    
    func delete(item: Item, completion: @escaping (Result<Bool, Error>) -> ()) {
        db.collection(FirebaseManager.itemsCollection).document(item.itemId).delete { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }
    
    func fetchUserItems(userId: String, completion: @escaping (Result<[Item], Error>) -> ()) {
        db.collection(FirebaseManager.itemsCollection).whereField("sellerId", isEqualTo: userId).getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else if let snapshot = snapshot {
                let items = snapshot.documents.map { Item($0.data()) }
                completion(.success(items.sorted{$0.listedDate.seconds > $1.listedDate.seconds}))
            }
        }
    }
    
    func fetchItemsInCategory(categoryName: String, completion: @escaping (Result<[Item], Error>) -> ()) {
        db.collection(FirebaseManager.itemsCollection).whereField("categoryName", isEqualTo: categoryName).getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else if let snapshot = snapshot {
                let items = snapshot.documents.map { Item($0.data()) }
                completion(.success(items.sorted{$0.listedDate.seconds > $1.listedDate.seconds}))
            }
        }
    }
    
    
    
    
    
    // MARK: Firebase Storage
    
    private let storageRef = Storage.storage().reference()
    
    func uploadPhoto(userId: String? = nil, itemId: String? = nil, image: UIImage, completion: @escaping (Result<URL, Error>) -> ()) {
        
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
          return
        }
        
        var photoReference: StorageReference!
        
        if let userId = userId { // coming from ProfileViewModel
          photoReference = storageRef.child("UserProfilePhotos/\(userId).jpg")
        } else if let itemId = itemId { // coming from SellItemViewModel
          photoReference = storageRef.child("ItemsPhotos/\(itemId).jpg")
        }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        let _ = photoReference.putData(imageData, metadata: metadata) { (metadata, error) in
          if let error = error {
            completion(.failure(error))
          } else if let _ = metadata {
            photoReference.downloadURL { (url, error) in
              if let error = error {
                completion(.failure(error))
              } else if let url = url {
                completion(.success(url))
              }
            }
          }
        }
    }
}
