//
//  SellItemViewModel.swift
//  Marketplace
//
//  Created by Paweł Przybyła on 31/08/2022.
//

import Foundation
import UIKit.UIImage

protocol SellItemDelegate: AnyObject {
    func imagePickerEvent()
}

final class SellItemViewModel {
    
    private let categoryProvider: CategoryProvider
    
    weak var sellItemDelegate: SellItemDelegate?
    
    private var title = ""
    private var category = ""
    private var price = 0.0
    private var description = ""
    private var image = UIImage()
    
    init(categoryProvider: CategoryProvider = CategoryProvider()) {
        self.categoryProvider = categoryProvider
    }
    
    lazy private(set) var  categoryNames = categoryProvider.getCategories().map {
        $0.name
    }
    
    var numberOfRowsInComponent: Int {
        return categoryNames.count
    }
    
    func getCategoryName(for row: Int) -> String {
        return categoryNames[row]
    }
    
    func pickerViewDidSelect(_ row: Int) {
        category = categoryNames[row]
    }
    
    func setTitle(_ title: String) {
        self.title = title
    }
    
    func setPrice(_ price: String) {
        self.price = Double(price) ?? 0.0
    }
    
    func setDescription(_ description: String) {
        self.description = description
    }
    
    func setImage(_ image: UIImage) {
        self.image = image
    }

}
