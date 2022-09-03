//
//  ProfileViewController.swift
//  Marketplace
//
//  Created by Paweł Przybyła on 03/09/2022.
//

import UIKit

class ProfileViewController: UIViewController {
    
    lazy private(set) var profileView = ProfileView(viewModel: viewModel)
    private var viewModel = ProfileViewModel()
    
    override func loadView() {
        view = profileView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
    }
    
    private func configureVC() {
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .systemBackground
        viewModel.profileDelegate = self
    }
    
    private func presentImagePickerController() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        let alertController = UIAlertController(title: "Change Your Profile Photo"
                                                , message: nil, preferredStyle: .actionSheet)
        
        let photoLibrary = UIAlertAction(title: "Photo Library", style: .default) { alertAction in
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(photoLibrary)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
}

extension ProfileViewController: ProfileDelegate {
    func imagePickerEvent() {
        presentImagePickerController()
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        profileView.profileImage.image = image
        viewModel.setImage(image)
        dismiss(animated: true)
    }
    
}
