//
//  ProfileViewModel.swift
//  Marketplace
//
//  Created by Paweł Przybyła on 03/09/2022.
//

import Foundation
import UIKit.UIImage

protocol ProfileDelegate: AnyObject {
    func imagePickerEvent()
}

final class ProfileViewModel {
    
    private var image = UIImage()
    var reloadTableViewClosure: () -> Void = { }
    weak var profileDelegate: ProfileDelegate?
    
    
    private var tableViewCellViewModels = [ItemCellViewModel]() {
        didSet {
            reloadTableViewClosure()
        }
    }
    func numberOfRowsInTableView() -> Int {
        tableViewCellViewModels.count
    }
    
    func getTableViewCellViewModel(at indexPath: IndexPath) -> ItemCellViewModel {
        tableViewCellViewModels[indexPath.row]
    }
    
    func setImage(_ image: UIImage) {
        self.image = image
    }
    
    
    
}
