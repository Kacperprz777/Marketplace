//
//  ItemCellViewModel.swift
//  Marketplace
//
//  Created by Paweł Przybyła on 31/08/2022.
//

import Foundation

struct ItemCellViewModel {
    
    private(set) var item: Item
    
    var itemName: String {
        item.itemName
    }
    
    var price: String {
        "$\(item.price)"
    }
    
    var imageURL: String {
        item.imageURL
    }
    
    init(_ item: Item) {
        self.item = item
    }
    
}
