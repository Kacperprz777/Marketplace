//
//  Item.swift
//  Marketplace
//
//  Created by Paweł Przybyła on 31/08/2022.
//

import Foundation
import Firebase

struct Item {
    let itemName: String
    let price: Double
    let sellerId: String
    let itemId: String
    let listedDate: Timestamp
    let categoryName: String
    let imageURL: String
    let description: String
    
}

extension Item {
  init(_ dictionary: [String: Any]) {
    self.itemName = dictionary["itemName"] as? String ?? "no item name"
    self.price = dictionary["price"] as? Double ?? 0.0
    self.itemId = dictionary["itemId"] as? String ?? "no item id"
    self.listedDate = dictionary["listedDate"] as? Timestamp ?? Timestamp(date: Date())
    self.sellerId = dictionary["sellerId"] as? String ?? "no seller id"
    self.categoryName = dictionary["categoryName"] as? String ?? "no category name"
    self.imageURL = dictionary["imageURL"] as? String ?? "no image url"
    self.description = dictionary["description"] as? String ?? "no description"
  }
}
