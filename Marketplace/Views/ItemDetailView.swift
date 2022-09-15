//
//  ItemDetailView.swift
//  Marketplace
//
//  Created by Paweł Przybyła on 14/09/2022.
//

import UIKit

class ItemDetailView: UIView {

    private var itemImage = UIImageView()
    private var priceLabel = UILabel()
    private var itemNameLabel = UILabel()
    private var itemDescriptionLabel = UILabel()

    private(set) var viewModel: ItemDetailViewModel
    
    init(viewModel: ItemDetailViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        configureItemImage()
        configureItemNameLabel()
        configurePriceLabel()
        configureItemDescriptionLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureItemImage() {
        addSubview(itemImage)
        itemImage.contentMode = .scaleAspectFit
        itemImage.clipsToBounds = true
        itemImage.loadImage(at: URL(string: viewModel.image))

        let padding: CGFloat = 8
        let heightAnchorConstant: CGFloat = 240
        itemImage.snp.makeConstraints { make in
            make.top.leading.equalTo(safeAreaLayoutGuide).offset(padding)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-padding)
            make.height.equalTo(heightAnchorConstant)
        }
    }
    
    private func configureItemNameLabel() {
        addSubview(itemNameLabel)
        itemNameLabel.text = viewModel.name
        itemNameLabel.font = UIFont.boldSystemFont(ofSize: 28)
        
        itemNameLabel.snp.makeConstraints { make in
            make.top.equalTo(itemImage.snp.bottom).offset(30)
            make.leading.equalTo(itemImage.snp.leading).offset(20)
        }
    }
    
    private func configurePriceLabel() {
        addSubview(priceLabel)
        priceLabel.text = viewModel.price
        priceLabel.font = UIFont.boldSystemFont(ofSize: 22)

        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(itemNameLabel.snp.bottom).offset(15)
            make.leading.equalTo(itemNameLabel.snp.leading).offset(10)
        }
        
    }
        
    private func configureItemDescriptionLabel() {
        addSubview(itemDescriptionLabel)
        itemDescriptionLabel.text = viewModel.description
        itemDescriptionLabel.numberOfLines = 0
        itemDescriptionLabel.font = UIFont.boldSystemFont(ofSize: 18)

        
        itemDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(10)
            make.leading.equalTo(priceLabel)
            make.trailing.equalTo(itemImage.snp.trailing).offset(-15)
        }
        
    }
                
    
    
}
