//
//  CategoryCell.swift
//  Marketplace
//
//  Created by Paweł Przybyła on 29/08/2022.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    
    private let categoryImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let categoryNameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureCategoryImage()
        configureCategoryNameLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCategoryImage() {
        contentView.addSubview(categoryImage)
        
        categoryImage.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self)
            make.bottom.equalTo(self).multipliedBy(0.7)
        }
    }
    
    private func configureCategoryNameLabel() {
        categoryNameLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
        categoryNameLabel.textAlignment = .center
        categoryNameLabel.textColor = .systemBlue
        categoryNameLabel.numberOfLines = 0
        

        
        contentView.addSubview(categoryNameLabel)
        
        categoryNameLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryImage.snp.bottom).offset(-15)
            make.trailing.leading.bottom.equalTo(self)
        }
    }
    
    func update(with viewModel: CategoryCellViewModel) {
        let image = UIImage(systemName: viewModel.imageSystemName, withConfiguration: UIImage.SymbolConfiguration(weight: .light))
        let colorImage = image?.withTintColor(.orange, renderingMode: .alwaysOriginal)
        categoryImage.image = colorImage
        
        categoryNameLabel.text = viewModel.name
    }
}
