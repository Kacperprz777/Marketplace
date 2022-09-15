//
//  ItemDetailViewModel.swift
//  Marketplace
//
//  Created by Paweł Przybyła on 14/09/2022.
//

import Foundation

final class ItemDetailViewModel {
    
    private let item: Item
    
    init(_ item: Item) {
        self.item = item
    }
    
    var image: String {
        item.imageURL
    }
    
    var price: String {
        "$\(item.price)"
    }
    
    var name: String {
        item.itemName
    }
    
    var description: String {
        item.description
    }
}
