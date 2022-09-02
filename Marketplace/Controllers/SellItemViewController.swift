//
//  SellItemViewController.swift
//  Marketplace
//
//  Created by Paweł Przybyła on 31/08/2022.
//

import UIKit

class SellItemViewController: UIViewController {

    private let sellItemView = SellItemView(viewModel: SellItemViewModel())
    
    override func loadView() {
        view = sellItemView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
    }
    
    private func configureVC() {
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .systemBackground
    }

}


