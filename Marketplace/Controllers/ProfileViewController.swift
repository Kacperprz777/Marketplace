//
//  ProfileViewController.swift
//  Marketplace
//
//  Created by Paweł Przybyła on 03/09/2022.
//

import UIKit

class ProfileViewController: UIViewController {
    
    private let firebaseManager = FirebaseManager()
    
    lazy private(set) var profileView = ProfileView(viewModel: viewModel)
    lazy private var viewModel = ProfileViewModel(firebaseEventsManager: firebaseManager)
    
    override func loadView() {
        view = profileView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.viewWillAppear()
        
    }
    
    override func signOut() {
        resetWindow(with: LoginViewController())
    }
    
    private func configureVC() {
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .systemBackground
        viewModel.profileDelegate = self
        profileView.profileImage.loadImage(at: firebaseManager.currentUserProfileImageURL)
    }
    
    private func presentImagePickerController() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        let alertController = UIAlertController(title: Alerts.changeProfilePhoto
                                                , message: nil, preferredStyle: .actionSheet)
        
        let photoLibrary = UIAlertAction(title: Alerts.photoLibrary, style: .default) { alertAction in
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true)
        }
        let cancelAction = UIAlertAction(title: Alerts.cancel, style: .cancel)
        
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
        let resizedImage = UIImage.resizeImage(originalImage: image, rect: profileView.profileImage.bounds)
        let imageData = resizedImage.jpegData(compressionQuality: 0.5)
        viewModel.uploadProfilePhoto(imageData: imageData)
        dismiss(animated: true)
    }
    
}
