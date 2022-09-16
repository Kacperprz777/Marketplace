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

protocol FirebaseManagerProtocol: AnyObject {
    
    func createNewUser(email: String, password: String, completion: @escaping (Result<Bool, Error>) -> ())
    func signExistingUser(email: String, password: String, completion: @escaping (Result<Bool, Error>) -> ())
    func resetUserPassword(with email: String, completion: @escaping (Result<Void, Error>) -> ())
    func createDatabaseUser(authDataResult: AuthDataResult , completion: @escaping (Result<Bool, Error>) -> ())
    func createItem(itemName: String, price: Double, category: String, description: String, completion: @escaping (Result<String, Error>) -> ())
    func uploadItemPhoto(itemId: String, imageData: Data, completion: @escaping (Result<String, Error>) -> ())
    func delete(item: Item, completion: @escaping (Result<Bool, Error>) -> ())
    func fetchUserItems(userId: String, completion: @escaping (Result<[Item], Error>) -> ())
    func uploadProfilePhoto(userId: String, imageData: Data, completion: @escaping (Result<String, Error>) -> ())
    func updateItemImageURL(_ url: String, documentId: String)
    func addSnapshotListenerOnItemsCollection(completion: @escaping ([Item]) -> ())
    func removeListener()
    func updateDatabaseUser(photoURL: String, completion: @escaping (Result<Bool, Error>) -> ())
    func createProfileChangeRequest(photoUrl: String)
    func signOut()
    var currentUserId: String? { get }
    var currentUserProfileImageURL: URL? { get }
}

final class FirebaseManager: FirebaseManagerProtocol {
    
    // MARK: Firebase Authentication
    
    private let auth = Auth.auth()
    
    var currentUserId: String? {
        auth.currentUser?.uid
    }
    
    var currentUserProfileImageURL: URL? {
        auth.currentUser?.photoURL
    }
    
    func createNewUser(email: String, password: String, completion: @escaping (Result<Bool, Error>) -> ()) {
        auth.createUser(withEmail: email, password: password) { [weak self] authDataResult, error in
            if let error = error {
                completion(.failure(error))
            } else {
                guard let user =  self?.auth.currentUser else { return }
                user.sendEmailVerification() { error in
                    guard let error = error else { return }
                    print(error.localizedDescription)
                }
                completion(.success(true))
                
                guard let authDataResult = authDataResult else { return }
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
        auth.signIn(withEmail: email, password: password) {[weak self] _, error in
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(error))
            } else {
                guard let user = self?.auth.currentUser else { return }
                completion(.success(user.isEmailVerified))
            }
        }
    }
    
    func resetUserPassword(with email: String, completion: @escaping (Result<Void, Error>) -> ()) {
        auth.sendPasswordReset(withEmail: email) { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func signOut() {
        do {
            try auth.signOut()
        } catch {
            print(error)
        }
    }
    
    // MARK: Firebase Firestore
    
    static let itemsCollection = "items"
    static let usersCollection = "users"
    
    private let db = Firestore.firestore()
    
    private var listener: ListenerRegistration?
    
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
        
        guard let user = auth.currentUser else { return }
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
                    category: String,
                    description: String,
                    completion: @escaping (Result<String, Error>) -> ()) {
        guard let user = auth.currentUser else { return }
        let documentRef = db.collection(FirebaseManager.itemsCollection).document()
        db.collection(FirebaseManager.itemsCollection)
            .document(documentRef.documentID)
            .setData(["itemName":itemName,
                      "price": price,
                      "itemId":documentRef.documentID,
                      "listedDate": Timestamp(date: Date()),
                      "sellerId": user.uid,
                      "categoryName": category,
                      "description": description,
                     ]) { (error) in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(documentRef.documentID))
                }
            }
    }
    
    func updateItemImageURL(_ url: String, documentId: String) {
        db.collection(FirebaseManager.itemsCollection).document(documentId).updateData(["imageURL" : url]) { error in
            if let error = error {
                print("Fail to update item \(error.localizedDescription)")
            } else {
                print("all went well with the update")
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
    
    func addSnapshotListenerOnItemsCollection(completion: @escaping ([Item]) -> ()) {
        listener = db.collection(FirebaseManager.itemsCollection).addSnapshotListener({ (snapshot, error) in
            if let error = error {
                print("addSnapshotListenerError: \(error.localizedDescription)")
            }
            else if let snapshot = snapshot {
                let items = snapshot.documents.map { Item($0.data()) }
                    .sorted{ $0.listedDate.seconds > $1.listedDate.seconds }
                completion(items)
            }
        })
    }
    
    func removeListener() {
        listener?.remove()
    }
    
    
    // MARK: Firebase Storage
    
    private let storageRef = Storage.storage().reference()
    
    func uploadItemPhoto(itemId: String, imageData: Data, completion: @escaping (Result<String, Error>) -> ()) {
        
        var photoReference: StorageReference!
        photoReference = storageRef.child("ItemsPhotos/\(itemId).jpg")
        
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
                        completion(.success(url.absoluteString))
                    }
                }
            }
        }
    }
    
    func uploadProfilePhoto(userId: String, imageData: Data, completion: @escaping (Result<String, Error>) -> ()) {
        
        var photoReference: StorageReference!
        photoReference = storageRef.child("UserProfilePhotos/\(userId).jpg")
        
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
                        completion(.success(url.absoluteString))
                    }
                }
            }
        }
    }
    
    func createProfileChangeRequest(photoUrl: String) {
        let request = Auth.auth().currentUser?.createProfileChangeRequest()
        request?.photoURL = URL(string: photoUrl)
        request?.commitChanges(completion: { error in
            if let error = error {
                print("Error changing profile \(error.localizedDescription)")
            } else {
                print("Profile successfully updated")
            }
        })
    }
    
}
