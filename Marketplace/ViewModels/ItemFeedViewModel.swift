//
//  ItemFeedViewModel.swift
//  Marketplace
//
//  Created by Paweł Przybyła on 29/08/2022.
//

import Foundation

final class ItemFeedViewModel {
        
    weak var firebaseEventsManager: FirebaseManagerProtocol?
    
    init(firebaseEventsManager: FirebaseManagerProtocol, categoryProvider: CategoryProvider = CategoryProvider()) {
        self.categoryProvider = categoryProvider
        self.firebaseEventsManager = firebaseEventsManager
    }

    func viewDidLoad() {
        loadCategoriesCollectionViewCells()
    }
    
    func viewDidAppear() {
        firebaseEventsManager?.addSnapshotListenerOnItemsCollection(completion: { [weak self] items in
            self?.items = items
        })
    }
    
    func viewWillDisappear() {
        firebaseEventsManager?.removeListener()
    }
    
    // MARK: UICollectionView
    
    private let categoryProvider: CategoryProvider
    lazy private var categories = categoryProvider.getCategories()
    lazy private var selectedCategoryName = categories.first?.name {
        didSet {
            items = { self.items }()
        }
    }

    private var collectionViewCellsViewModels: [CategoryCellViewModel] = []
    
    private func loadCategoriesCollectionViewCells() {
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
    
    func didSelectItemAt(_ indexPath: IndexPath) {
        selectedCategoryName = categories[indexPath.row].name
    }
    
    
    // MARK: UITableView
    
    enum tableViewState {
        case empty
        case notEmpty
    }
    
    private var items = [Item]() {
        didSet {
            let filteredItems = items.filter { $0.categoryName == selectedCategoryName}
            tableViewCellViewModels = filteredItems.map { ItemCellViewModel($0) }
        }
    }
    
    var reloadTableViewClosure: () -> Void = { }
    var showItemClosure: (Item) -> Void = { _ in }
    
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
    
    func didSelectRowAt(_ indexPath: IndexPath) {
        let item = tableViewCellViewModels[indexPath.row].item
        showItemClosure(item)
    }
}
