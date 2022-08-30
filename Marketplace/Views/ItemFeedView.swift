//
//  ItemFeedView.swift
//  Marketplace
//
//  Created by Paweł Przybyła on 29/08/2022.
//

import UIKit

class ItemFeedView: UIView {

    private var categoriesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(CategoryCell.self, forCellWithReuseIdentifier: "categories")
        return cv
    }()
    
    private(set) var viewModel: ItemFeedViewModel
    
    init(viewModel: ItemFeedViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        configureCategoriesCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCategoriesCollectionView() {
        addSubview(categoriesCollectionView)
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        
        categoriesCollectionView.backgroundColor = .systemBackground
        categoriesCollectionView.showsHorizontalScrollIndicator = false
        
        categoriesCollectionView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.equalTo(safeAreaLayoutGuide).offset(10)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-10)
            make.height.equalTo(self).multipliedBy(0.15)
        }
    }
}

extension ItemFeedView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: categoriesCollectionView.frame.width/3 , height: categoriesCollectionView.frame.width/3)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
 
            guard let cell = categoriesCollectionView.dequeueReusableCell(withReuseIdentifier: "categories", for: indexPath) as? CategoryCell else {
                fatalError("could not downcaset to CategoryCell")
            }
        
            let cellViewModel = viewModel.getCellViewModel(at: indexPath)
        
            cell.update(with: cellViewModel)
            return cell
        }
}
