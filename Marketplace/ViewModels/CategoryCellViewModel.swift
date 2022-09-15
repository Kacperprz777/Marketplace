//
//  CategoryCellViewModel.swift
//  Marketplace
//
//  Created by Paweł Przybyła on 29/08/2022.
//

import Foundation

struct CategoryCellViewModel {
    
    private let category: Category
    
    var imageSystemName: String {
        category.imageSystemName
    }
    
    var name: String {
        category.name
    }
    
    init(_ category: Category) {
        self.category = category
    }
    

}
