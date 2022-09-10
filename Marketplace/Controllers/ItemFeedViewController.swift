//
//  ItemFeedViewController.swift
//  Marketplace
//
//  Created by Paweł Przybyła on 29/08/2022.
//

import UIKit

class ItemFeedViewController: UIViewController {

    private let firebaseManager = FirebaseManager()
    
    lazy private var viewModel = ItemFeedViewModel(firebaseEventsManager: firebaseManager)
    lazy private(set) var itemFeedView = ItemFeedView(viewModel: viewModel)
    
    override func loadView() {
        view = itemFeedView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        viewModel.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.viewDidAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.viewWillDisappear()
    }
    
    private func configureVC() {
        //navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .systemBackground
        navigationItem.title = "Marketplace"
    }


}
