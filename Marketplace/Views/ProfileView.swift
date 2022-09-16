//
//  ProfileView.swift
//  Marketplace
//
//  Created by Paweł Przybyła on 03/09/2022.
//

import UIKit

class ProfileView: UIView {
    
    
    private let editPhotoButton = UIButton.makeEditPhotoButton()
    private let signOutButton = UIButton.makeSignOutButton()
    private let myItemsTableView = UITableView()
    private(set) var viewModel: ProfileViewModel
    var profileImage = UIImageView()
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        configureProfileImage()
        configureEditPhotoButton()
        configureSignOutButton()
        configureMyItemsTableView()
        
        viewModel.reloadTableViewClosure = { [weak self] in
            self?.myItemsTableView.reloadData()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureProfileImage() {
        let ultraLightConfiguration = UIImage.SymbolConfiguration(weight: .ultraLight)
        
        addSubview(profileImage)
        profileImage.backgroundColor = .systemGray6
        profileImage.contentMode = .scaleAspectFit
        profileImage.clipsToBounds = true
        profileImage.image = UIImage(systemName: Images.person, withConfiguration: ultraLightConfiguration)
        profileImage.layer.cornerRadius = 20
        
        profileImage.snp.makeConstraints { make in
            make.centerX.equalTo(safeAreaLayoutGuide)
            make.top.equalTo(safeAreaLayoutGuide).offset(40)
            make.width.height.equalTo(140)
        }
    }
    
    private func configureEditPhotoButton() {
        addSubview(editPhotoButton)
        editPhotoButton.layer.cornerRadius = 22
        editPhotoButton.addTarget(self, action: #selector(editPhotoButtonTapped), for: .touchUpInside)
        
        editPhotoButton.snp.makeConstraints { make in
            make.leading.equalTo(profileImage.snp.trailing).offset(-20)
            make.top.equalTo(profileImage.snp.top).offset(110)
        }
    }
    
    private func configureSignOutButton() {
        addSubview(signOutButton)
        signOutButton.addTarget(self, action: #selector(signOutButtonTapped), for: .touchUpInside)
        
        signOutButton.snp.makeConstraints { make in
            make.leading.equalTo(editPhotoButton.snp.trailing)
            make.top.equalTo(editPhotoButton.snp.top).offset(-50)
            make.width.equalTo(90)
            make.height.equalTo(30)
            
        }
    }
    
    private func configureMyItemsTableView() {
        addSubview(myItemsTableView)
        myItemsTableView.delegate = self
        myItemsTableView.dataSource = self
        myItemsTableView.register(ItemCell.self, forCellReuseIdentifier: Constants.itemCell)
        myItemsTableView.backgroundColor = .systemGray6
        myItemsTableView.layer.cornerRadius = 10
        
        myItemsTableView.snp.makeConstraints { make in
            make.top.equalTo(profileImage.snp.bottom).offset(40)
            make.leading.equalTo(safeAreaLayoutGuide).offset(10)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-10)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
    @objc private func editPhotoButtonTapped() {
        viewModel.profileDelegate?.imagePickerEvent()
    }
    
    @objc private func signOutButtonTapped() {
        viewModel.signOut() { [weak self] in
            self?.signOut()
        }
    }
}

extension ProfileView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRowsInTableView()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = myItemsTableView.dequeueReusableCell(withIdentifier: Constants.itemCell, for: indexPath) as? ItemCell else {
            fatalError("could not downcaset to ItemCell")
        }
        
        let cellViewModel = viewModel.getTableViewCellViewModel(at: indexPath)
        cell.update(with: cellViewModel)
        cell.itemImage.loadImage(at: URL(string: cellViewModel.imageURL))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        return viewModel.deleteItem(at: indexPath)
    }
    
}

extension ProfileView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        Constants.myItems
    }
    
}
