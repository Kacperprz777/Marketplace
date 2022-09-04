//
//  ItemFeedViewController.swift
//  Marketplace
//
//  Created by Paweł Przybyła on 29/08/2022.
//

import UIKit

class ItemFeedViewController: UIViewController {

    private var viewModel = ItemFeedViewModel()
    lazy private(set) var itemFeedView = ItemFeedView(viewModel: viewModel)
    
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
