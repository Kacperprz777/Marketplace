//
//  SellItemViewModel.swift
//  Marketplace
//
//  Created by Paweł Przybyła on 31/08/2022.
//

import Foundation

protocol SellItemDelegate: AnyObject {
    func imagePickerEvent()
}

final class SellItemViewModel {
        
    private let categoryProvider: CategoryProvider
    
    weak var sellItemDelegate: SellItemDelegate?
    weak var firebaseEventsManager: FirebaseManagerProtocol?
    
    private var title = ""
    private var category = ""
    private var price = 0.0
    private var description = ""
    
    init(categoryProvider: CategoryProvider = CategoryProvider(), firebaseEventsManager: FirebaseManagerProtocol) {
        self.categoryProvider = categoryProvider
        self.firebaseEventsManager = firebaseEventsManager
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
    
    func sellItem(imageData: Data?, handler: @escaping (Error?) -> Void ) {
        guard let imageData = imageData, !title.isEmpty, !category.isEmpty, !description.isEmpty, price > 0.0  else { return }
        
        firebaseEventsManager?.createItem(itemName: title, price: price, category: category, description: description, completion: { [weak self] createItemResult in
            switch createItemResult {
            case .failure(let error):
                //alert
                print(error.localizedDescription)
                break
            case .success(let documentId):
                self?.firebaseEventsManager?.uploadItemPhoto(itemId: documentId, imageData: imageData, completion: {[weak self] uploadItemPhotoResult in
                    switch uploadItemPhotoResult {
                    case .failure(let error):
                        print(error.localizedDescription)
                    case .success(let url):
                        self?.firebaseEventsManager?.updateItemImageURL(url, documentId: documentId)
                        self?.resetItemProperties()
                        handler(nil)
                    }
                })
            }
        })
    }
    
    private func resetItemProperties() {
        title = ""
        category = ""
        price = 0.0
        description = ""
    }

}
