//
//  ItemFeedViewModel.swift
//  Marketplace
//
//  Created by Paweł Przybyła on 29/08/2022.
//

import Foundation

final class ItemFeedViewModel {
        

    private var cellsViewModel: [CategoryCellViewModel] = []
    private let categoryProvider: CategoryProvider
    
    init(categoryProvider: CategoryProvider) {
        self.categoryProvider = categoryProvider
    }
    
    func viewDidLoad() {
        loadCategoriesCollectionViewCells()
    }
    
    private func loadCategoriesCollectionViewCells() {
        let categories = categoryProvider.getCategories()
        cellsViewModel = categories.map {
            CategoryCellViewModel($0)
        }
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> CategoryCellViewModel {
        return cellsViewModel[indexPath.row]
    }
    
    func numberOfRows() -> Int {
        return cellsViewModel.count
    }
}
