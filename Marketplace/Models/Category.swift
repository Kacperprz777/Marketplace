//
//  Category.swift
//  Marketplace
//
//  Created by Paweł Przybyła on 29/08/2022.
//

import Foundation

struct Category {
    let imageSystemName: String
    let name: String
}


struct CategoryProvider {
    func getCategories() -> [Category] {
        return [
            Category(imageSystemName: "laptopcomputer.and.iphone", name: "Electronics"),
            Category(imageSystemName: "bed.double", name: "Home and Garden"),
            Category(imageSystemName: "scissors", name: "Fashion and Accessories"),
            
            Category(imageSystemName: "car", name: "Cars"),
            Category(imageSystemName: "airplane", name: "Other Vehicles"),
            Category(imageSystemName: "gamecontroller", name: "Sports and Games"),
            
            Category(imageSystemName: "smiley", name: "Baby and Child"),
            Category(imageSystemName: "book", name: "Movies, Books and Music"),
            Category(imageSystemName: "wrench", name: "Jobs"),
            
            Category(imageSystemName: "paintbrush", name: "Services"),
            Category(imageSystemName: "house", name: "Real Estate"),
            Category(imageSystemName: "tag", name: "Other"),
        ]
    }
}
