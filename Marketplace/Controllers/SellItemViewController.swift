//
//  SellItemViewController.swift
//  Marketplace
//
//  Created by Paweł Przybyła on 31/08/2022.
//

import UIKit

class SellItemViewController: UIViewController {

    private let firebaseManager = FirebaseManager()
    
    lazy private(set) var sellItemView = SellItemView(viewModel: viewModel)
    lazy private var viewModel = SellItemViewModel(firebaseEventsManager: firebaseManager)
    
    override func loadView() {
        view = sellItemView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
    }
    
    override func showAlert(message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        showAlert(title: nil, message: message)
    }
    
    private func configureVC() {
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .systemBackground
        viewModel.sellItemDelegate = self
    }
    
    private func presentImagePickerController() {
        view.endEditing(true)
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        let alertController = UIAlertController(title: Alerts.chosePhotoOption, message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: Alerts.camera, style: .default) { alertAction in
          imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true)
        }
        let photoLibrary = UIAlertAction(title: Alerts.photoLibrary, style: .default) { alertAction in
          imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true)
        }
        let cancelAction = UIAlertAction(title: Alerts.cancel, style: .cancel)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
          alertController.addAction(cameraAction)
        }
        alertController.addAction(photoLibrary)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }

}

extension SellItemViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        sellItemView.itemImage.image = image
        dismiss(animated: true)
    }
    
}

extension SellItemViewController: SellItemDelegate {
    func imagePickerEvent() {
        presentImagePickerController()
    }
    
    
}


