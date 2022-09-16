//
//  SellItemView.swift
//  Marketplace
//
//  Created by Paweł Przybyła on 31/08/2022.
//

import UIKit

class SellItemView: UIView {
    
    private let scrollView = UIScrollView()
    private let titleTextField = BindingTextField(placeholderText: Constants.title)
    private let priceTextField = BindingTextField(placeholderText: Constants.price)
    private let descriptionTextView = UITextView()
    private let sellButton = UIButton.makeButton(title: Constants.sell)
    private let descriptionPlaceholder = UILabel()
    
    private var categoriesPicker = UIPickerView()
    var itemImage = UIImageView()
    private(set) var viewModel: SellItemViewModel
    
    private lazy var longPressGesture: UITapGestureRecognizer = {
      let gesture = UITapGestureRecognizer()
      gesture.addTarget(self, action: #selector(showPhotoOptions))
      return gesture
    }()
    
    init(viewModel: SellItemViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        configureScrollView()
        configureItemImage()
        configureTitleTextField()
        configureCategoriesPicker()
        configurePriceTextField()
        configureDescriptionTextView()
        configureDescriptionPlaceholder()
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
        let padding: CGFloat = 30
        scrollView.addSubview(itemImage)
        itemImage.backgroundColor = .systemGray6
        itemImage.image = Images.addPhotoImage
        itemImage.contentMode = .scaleAspectFit
        itemImage.layer.cornerRadius = 10
        itemImage.clipsToBounds = true
        itemImage.isUserInteractionEnabled = true
        itemImage.addGestureRecognizer(longPressGesture)
        
        itemImage.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.top).offset(10)
            make.centerX.equalTo(scrollView.snp.centerX)
            make.leading.equalTo(scrollView.snp.leading).offset(padding)
            make.trailing.equalTo(scrollView.snp.trailing).offset(-padding)
            make.height.equalTo(240)
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
            make.top.equalTo(itemImage.snp.bottom).offset(10)
            make.leading.trailing.equalTo(itemImage)

        }
    }
    
    private func configureCategoriesPicker(){
        scrollView.addSubview(categoriesPicker)
        categoriesPicker.layer.cornerRadius = 10
        categoriesPicker.dataSource = self
        categoriesPicker.delegate = self
        categoriesPicker.selectRow(0, inComponent: 0, animated: true)
        pickerView(categoriesPicker, didSelectRow: 0, inComponent: 0)
        
        categoriesPicker.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(10)
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
            make.top.equalTo(categoriesPicker.snp.bottom).offset(10)
            make.leading.trailing.equalTo(titleTextField)
        }
    }
    
    private func configureDescriptionTextView() {
        scrollView.addSubview(descriptionTextView)
        descriptionTextView.delegate = self
        descriptionTextView.layer.cornerRadius = 10
        descriptionTextView.backgroundColor = .systemGray4
        descriptionTextView.font = UIFont.systemFont(ofSize: 18)
        descriptionTextView.autocorrectionType = .no
        
        descriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(priceTextField.snp.bottom).offset(10)
            make.leading.trailing.equalTo(titleTextField)
            make.height.equalTo(120)
        }
    }
    
    private func configureDescriptionPlaceholder() {
        let padding: CGFloat = 8
        scrollView.addSubview(descriptionPlaceholder)
        descriptionPlaceholder.text = Constants.description
        descriptionPlaceholder.font = UIFont.systemFont(ofSize: 18)
        descriptionPlaceholder.textColor = .lightGray
        
        descriptionPlaceholder.snp.makeConstraints { make in
            make.top.equalTo(descriptionTextView).offset(padding)
            make.leading.equalTo(descriptionTextView).offset(padding)
        }
    }
    
    private func configureSellButton() {
        scrollView.addSubview(sellButton)
        
        sellButton.addTarget(self, action: #selector(sellButtonTapped), for: .touchUpInside)
        
        sellButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionTextView.snp.bottom).offset(20)
            make.centerX.equalTo(scrollView)
            make.width.equalTo(150)
            make.height.equalTo(40)

        }
    }
    
    @objc private func sellButtonTapped() {
        endEditing(true)
        sellButton.isEnabled = false
        enableSellButton()
        guard let image = itemImage.image else { return }
        let resizedImage = UIImage.resizeImage(originalImage: image, rect: itemImage.bounds)
        let imageData = resizedImage.jpegData(compressionQuality: 0.8)
        viewModel.sellItem(imageData: imageData) { [weak self] error in
            if let error = error {
                self?.showAlert(message: error.localizedDescription)

            }
            self?.itemImage.image = Images.addPhotoImage
            self?.titleTextField.text = ""
            self?.priceTextField.text = ""
            self?.descriptionTextView.text = ""
            self?.resetPickerView()
            self?.sellButton.isEnabled = true
            self?.showAlert(message: Alerts.addItemSuccess)
            self?.descriptionPlaceholder.isHidden = false
        }
    }
    
    private func enableSellButton() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.sellButton.isEnabled = true
        }
    }
    
    private func resetPickerView() {
        categoriesPicker.selectRow(0, inComponent: 0, animated: true)
        pickerView(categoriesPicker, didSelectRow: 0, inComponent: 0)
    }
    private func configureTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(UIView.endEditing))
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func showPhotoOptions() {
        viewModel.sellItemDelegate?.imagePickerEvent()
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

extension SellItemView: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let currentText = textView.text else { return false }
        let text = currentText + text
        viewModel.setDescription(text)
        return true
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 150), animated: true)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        descriptionPlaceholder.isHidden =  viewModel.isTextViewPlaceholderHidden(textView.text)
    }
}

