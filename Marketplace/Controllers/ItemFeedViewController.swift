//
//  ItemFeedViewController.swift
//  Marketplace
//
//  Created by Paweł Przybyła on 29/08/2022.
//

import UIKit

class ItemFeedViewController: UIViewController {

    var viewModel: ItemFeedViewModel!
    lazy private(set) var itemFeedView = ItemFeedView(viewModel: viewModel)
    
    init(viewModel: ItemFeedViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = itemFeedView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        viewModel.viewDidLoad()
    }
    
    private func configureVC() {
        //navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .systemBackground
        navigationItem.title = "Marketplace"
    }


}
