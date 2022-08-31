//
//  ItemFeedView.swift
//  Marketplace
//
//  Created by Paweł Przybyła on 29/08/2022.
//

import UIKit

class ItemFeedView: UIView {

    private let itemFeedTableView = UITableView()

    private var categoriesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(CategoryCell.self, forCellWithReuseIdentifier: "categories")
        return cv
    }()
    
    private var emptyStateImageView = UIImageView()
    private(set) var viewModel: ItemFeedViewModel
    
    init(viewModel: ItemFeedViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        configureCategoriesCollectionView()
        configureItemFeedTableView()
        configureEmptyStateImageView()
        
        viewModel.reloadTableViewClosure = { [weak self] in
            self?.itemFeedTableView.reloadData()
            self?.itemFeedTableView.backgroundView?.isHidden = viewModel.isInEmptyState
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureCategoriesCollectionView() {
        addSubview(categoriesCollectionView)
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        
        categoriesCollectionView.backgroundColor = .systemGray6
        categoriesCollectionView.layer.cornerRadius = 10
        categoriesCollectionView.showsHorizontalScrollIndicator = false
        
        categoriesCollectionView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.equalTo(safeAreaLayoutGuide).offset(10)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-10)
            make.height.equalTo(self).multipliedBy(0.15)
        }
    }
    
    private func configureItemFeedTableView() {
        addSubview(itemFeedTableView)
        
        itemFeedTableView.register(ItemCell.self, forCellReuseIdentifier: "itemCell")
        itemFeedTableView.delegate = self
        itemFeedTableView.dataSource = self
        
        itemFeedTableView.backgroundColor = .systemGray6
        itemFeedTableView.layer.cornerRadius = 10
        itemFeedTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        itemFeedTableView.snp.makeConstraints { make in
            make.top.equalTo(categoriesCollectionView.snp_bottom).offset(5)
            make.leading.trailing.equalTo(categoriesCollectionView)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-10)
        }
    }
    
    private func configureEmptyStateImageView() {
        addSubview(emptyStateImageView)
        
        emptyStateImageView.image = UIImage(named: "emptyTableViewImage")
        itemFeedTableView.backgroundView = emptyStateImageView
        
        emptyStateImageView.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(itemFeedTableView)
            make.width.height.equalTo(300)
        }
    }
}

extension ItemFeedView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: categoriesCollectionView.frame.width/3 , height: categoriesCollectionView.frame.width/3)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInCollectionView()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
 
            guard let cell = categoriesCollectionView.dequeueReusableCell(withReuseIdentifier: "categories", for: indexPath) as? CategoryCell else {
                fatalError("could not downcaset to CategoryCell")
            }
        
            let cellViewModel = viewModel.getCollectionViewCellViewModel(at: indexPath)
        
            cell.update(with: cellViewModel)
            return cell
        }
}

extension ItemFeedView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRowsInTableView()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = itemFeedTableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as? ItemCell else {
            fatalError("could not downcaset to ItemCell")
        }
        
        let cellViewModel = viewModel.getTableViewCellViewModel(at: indexPath)
        
        cell.update(with: cellViewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
}
