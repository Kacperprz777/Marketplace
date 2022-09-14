//
//  ProfileViewModel.swift
//  Marketplace
//
//  Created by Paweł Przybyła on 03/09/2022.
//

import Foundation

protocol ProfileDelegate: AnyObject {
    func imagePickerEvent()
}

final class ProfileViewModel {
    
    var reloadTableViewClosure: () -> Void = { }
    weak var profileDelegate: ProfileDelegate?
    weak var firebaseEventsManager: FirebaseManagerProtocol?
    
    private(set) var tableViewCellViewModels = [ItemCellViewModel]() {
        didSet {
            reloadTableViewClosure()
        }
    }
    
    init(firebaseEventsManager: FirebaseManagerProtocol) {
        self.firebaseEventsManager = firebaseEventsManager
    }
    
    func viewWillAppear() {
        fetchUserItems()
    }
    
    func numberOfRowsInTableView() -> Int {
        tableViewCellViewModels.count
    }
    
    func getTableViewCellViewModel(at indexPath: IndexPath) -> ItemCellViewModel {
        tableViewCellViewModels[indexPath.row]
    }
    
    private func getItem(at indexPath: IndexPath) -> Item {
        tableViewCellViewModels[indexPath.row].item
    }
    
    func deleteItem(at indexPath: IndexPath) {
        let item = getItem(at: indexPath)
        firebaseEventsManager?.delete(item: item, completion: { result in
            switch result {
            case .failure(let error):
                print("Deletion error: \(error.localizedDescription)")
            case .success(_):
                print("Deleted successfully")
            }
        })
        tableViewCellViewModels.remove(at: indexPath.row)
    }
    
    private func fetchUserItems() {
        guard let userId = firebaseEventsManager?.currentUserId else { return }
        firebaseEventsManager?.fetchUserItems(userId: userId, completion: { [weak self] result in
            switch result {
            case .failure(let error):
                print("Fetching error: \(error.localizedDescription)")
            case .success(let items):
                self?.tableViewCellViewModels = items.map { ItemCellViewModel($0) }
            }
        })
    }
    
    func uploadProfilePhoto(imageData: Data?) {
        guard let imageData = imageData, let userId = firebaseEventsManager?.currentUserId else { return }
        firebaseEventsManager?.uploadProfilePhoto(userId: userId, imageData: imageData, completion: { [weak self] result in
            switch result {
            case .failure(let error):
                print("Error uploading photo \(error.localizedDescription)")
            case .success(let url):
                self?.firebaseEventsManager?.updateDatabaseUser(photoURL: url, completion: { result in
                    switch result {
                    case .failure(let error):
                        print("Error updating db user \(error.localizedDescription)")
                    case .success(_):
                        print("successfully updated db user")
                        
                    }
                })
                self?.firebaseEventsManager?.createProfileChangeRequest(photoUrl: url)
            }
        })
    }
    
    func signOut(completion: @escaping () -> ()) {
        firebaseEventsManager?.signOut()
        completion()
    }
    
    
    
}
