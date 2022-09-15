//
//  ItemDetailViewController.swift
//  Marketplace
//
//  Created by Paweł Przybyła on 14/09/2022.
//

import UIKit

class ItemDetailViewController: UIViewController {

    let item: Item
    lazy private var itemDetailView = ItemDetailView(viewModel: viewModel)
    lazy private var viewModel = ItemDetailViewModel(item)
    
    init(_ item: Item) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = itemDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
    }
    
    private func configureVC() {
        view.backgroundColor = .systemBackground
    }


}
