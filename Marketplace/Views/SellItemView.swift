//
//  SellItemView.swift
//  Marketplace
//
//  Created by Paweł Przybyła on 31/08/2022.
//

import UIKit

class SellItemView: UIView {
    
    private let scrollView = UIScrollView()
    private let titleTextField = BindingTextField(placeholderText: "Title")
    private let priceTextField = BindingTextField(placeholderText: "Price")
    private let descriptionTextField = BindingTextField(placeholderText: "Description", padding: UIEdgeInsets(top: -100, left: 8, bottom: 0, right: 8))
    private let sellButton = UIButton.makeButton(title: "Sell")
    
    private var categoriesPicker = UIPickerView()
    private var itemImage = UIImageView()
    private(set) var viewModel: SellItemViewModel
    
    init(viewModel: SellItemViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        configureScrollView()
        configureItemImage()
        configureTitleTextField()
        configureCategoriesPicker()
        configurePriceTextField()
        configureDescriptionTextField()
        configureSellButton()
        configureTapGesture()

        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureScrollView() {
        addSubview(scrollView)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.trailing.bottom.leading.equalTo(self)
        }
    }
    
    private func configureItemImage(){
        scrollView.addSubview(itemImage)
        
        itemImage.backgroundColor = .systemGray6
        itemImage.image = UIImage(named: "addPhotoImage")
        itemImage.contentMode = .scaleAspectFit
        itemImage.layer.cornerRadius = 10
        itemImage.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp_top).offset(10)
            make.centerX.equalTo(scrollView.snp_centerX)
            make.leading.equalTo(scrollView.snp_leading).offset(20)
            make.trailing.equalTo(scrollView.snp_trailing).offset(-20)
            make.height.equalTo(220)
        }
    }
    
    private func configureTitleTextField(){
        scrollView.addSubview(titleTextField)
        titleTextField.delegate = self
        titleTextField.backgroundColor = .systemGray5
        titleTextField.bind { [weak self] text in
            self?.viewModel.setTitle(text)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(itemImage.snp_bottom).offset(10)
            make.leading.trailing.equalTo(itemImage)

        }
    }
    
    private func configureCategoriesPicker(){
        scrollView.addSubview(categoriesPicker)
        categoriesPicker.layer.cornerRadius = 10
        categoriesPicker.dataSource = self
        categoriesPicker.delegate = self
        
        categoriesPicker.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp_bottom).offset(10)
            make.leading.trailing.equalTo(titleTextField)
            make.height.equalTo(120)
        }
    }
    
    private func configurePriceTextField(){
        scrollView.addSubview(priceTextField)
        priceTextField.delegate = self
        priceTextField.backgroundColor = .systemGray5
        priceTextField.keyboardType = .decimalPad
        priceTextField.bind { [weak self] text in
            self?.viewModel.setPrice(text)
        }

        priceTextField.snp.makeConstraints { make in
            make.top.equalTo(categoriesPicker.snp_bottom).offset(10)
            make.leading.trailing.equalTo(titleTextField)
        }
    }
    
    private func configureDescriptionTextField(){
        scrollView.addSubview(descriptionTextField)
        descriptionTextField.delegate = self
        descriptionTextField.backgroundColor = .systemGray4
        descriptionTextField.bind { [weak self] text in
            self?.viewModel.setDescription(text)
        }
        
        descriptionTextField.snp.makeConstraints { make in
            make.top.equalTo(priceTextField.snp_bottom).offset(10)
            make.leading.trailing.equalTo(titleTextField)
            make.height.equalTo(120)
        }
    }
    
    private func configureSellButton() {
        scrollView.addSubview(sellButton)
        
        sellButton.addTarget(self, action: #selector(sellButtonTapped), for: .touchUpInside)
        
        sellButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionTextField.snp_bottom).offset(20)
            make.centerX.equalTo(scrollView)
            make.width.equalTo(150)
            make.height.equalTo(40)

        }
    }
    
    @objc private func sellButtonTapped() {
        
    }
    
    private func configureTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(UIView.endEditing))
        addGestureRecognizer(tapGesture)
    }
}

extension SellItemView: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 150), animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
}

extension SellItemView: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        viewModel.numberOfRowsInComponent
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        viewModel.getCategoryName(for: row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel.pickerViewDidSelect(row)
    }
}
