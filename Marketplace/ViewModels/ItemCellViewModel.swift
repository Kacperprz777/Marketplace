//
//  ItemCellViewModel.swift
//  Marketplace
//
//  Created by Paweł Przybyła on 31/08/2022.
//

import Foundation

struct ItemCellViewModel {
    
    private let item: Item
    
    init(_ item: Item) {
        self.item = item
    }
    
    var itemName: String {
        item.itemName
    }
    
    var price: Double {
        item.price
    }
    
    var imageURL: String {
        item.imageURL
    }
    
}
