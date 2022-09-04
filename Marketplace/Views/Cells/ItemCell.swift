//
//  ItemCell.swift
//  Marketplace
//
//  Created by Paweł Przybyła on 30/08/2022.
//

import UIKit

class ItemCell: UITableViewCell {
    
    private var itemImage = UIImageView()
    private var itemNameLabel = UILabel()
    private var dateLabel = UILabel()
    private var priceLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "itemCell")
        configureItemImage()
        configureItemNameLabel()
        configureDateLabel()
        configurePriceLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureItemImage() {
        contentView.addSubview(itemImage)
        itemImage.contentMode = .scaleAspectFit
        itemImage.image = UIImage(systemName: "photo.fill")
        itemImage.backgroundColor = .systemOrange
        itemImage.layer.cornerRadius = 10
        
        itemImage.snp.makeConstraints { make in
            make.top.leading.equalTo(self).offset(10)
            make.bottom.equalTo(self).offset(-10)
            make.width.equalTo(100)
        }
    }
    
    private func configureItemNameLabel() {
        contentView.addSubview(itemNameLabel)
        itemNameLabel.text = "itemNameLabel"
        itemNameLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
        
        itemNameLabel.snp.makeConstraints { make in
            make.top.equalTo(self).offset(15)
            make.leading.equalTo(itemImage.snp.trailing).offset(15)
        }
    }
    
    private func configureDateLabel() {
        contentView.addSubview(dateLabel)
        dateLabel.text = "dateLabel"
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(itemNameLabel.snp.bottom)
            make.leading.equalTo(itemImage.snp.trailing).offset(15)
        }
    }
    
    private func configurePriceLabel() {
        contentView.addSubview(priceLabel)
        priceLabel.text = "priceLabel"
        priceLabel.snp.makeConstraints { make in
            make.trailing.equalTo(self).offset(-20)
            make.bottom.equalTo(self).offset(-20)
        }
    }
    
    func update(with viewModel: ItemCellViewModel) {
        //itemImage
        //dateLabel
        itemNameLabel.text = viewModel.itemName
        priceLabel.text = String(viewModel.price)
        
        
        
    }
    
}
