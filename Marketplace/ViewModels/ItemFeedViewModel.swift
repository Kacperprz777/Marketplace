//
//  ItemFeedViewModel.swift
//  Marketplace
//
//  Created by Paweł Przybyła on 29/08/2022.
//

import Foundation

final class ItemFeedViewModel {
        
    init(categoryProvider: CategoryProvider = CategoryProvider()) {
        self.categoryProvider = categoryProvider
    }
    
    func viewDidLoad() {
        loadCategoriesCollectionViewCells()
    }
    
    // MARK: UICollectionView
    
    private var collectionViewCellsViewModels: [CategoryCellViewModel] = []
    private let categoryProvider: CategoryProvider

    private func loadCategoriesCollectionViewCells() {
        let categories = categoryProvider.getCategories()
        collectionViewCellsViewModels = categories.map {
            CategoryCellViewModel($0)
        }
    }
    
    func getCollectionViewCellViewModel(at indexPath: IndexPath) -> CategoryCellViewModel {
        return collectionViewCellsViewModels[indexPath.row]
    }
    
    func numberOfRowsInCollectionView() -> Int {
        return collectionViewCellsViewModels.count
    }
    
    // MARK: UITableView
    
    enum tableViewState {
        case empty
        case notEmpty
    }
    
    var reloadTableViewClosure: () -> Void = { }
    private var state: tableViewState = .empty
    private var tableViewCellViewModels = [ItemCellViewModel]() {
        didSet {
            toogleState()
            reloadTableViewClosure()
        }
    }
    
    var isInEmptyState: Bool {
        if case .notEmpty = state {
             return true
        } else {
            return false
        }
    }
    
    private func toogleState() {
        state = tableViewCellViewModels.isEmpty ? .empty : .notEmpty
   }
    
    func numberOfRowsInTableView() -> Int {
        tableViewCellViewModels.count
    }
    
    func getTableViewCellViewModel(at indexPath: IndexPath) -> ItemCellViewModel {
        tableViewCellViewModels[indexPath.row]
    }
}
