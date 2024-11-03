//
//  ProfileViewController.swift
//  WordleWarriors
//
//  Created by Nishanth Gopinath on 11/16/24.
//

import UIKit

class ProfileViewController: UIViewController {
    
    let profileView = ProfileView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view = profileView

        profileView.backButton.addTarget(self, action: #selector(onBackButtonTapped), for: .touchUpInside)
        profileView.profilePhotoButton.addTarget(self, action: #selector(onProfilePhotoTapped), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
    }
    
    @objc private func onBackButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc private func onProfilePhotoTapped() {
        let actionSheet = UIAlertController(title: "Profile Photo", message: "Choose an option", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in self.openCamera() }))
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in self.openGallery() }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }

    private func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }

    private func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let selectedImage = info[.editedImage] as? UIImage {
            profileView.profilePhotoButton.setImage(selectedImage.withRenderingMode(.alwaysOriginal), for: .normal)
            profileView.profilePhotoButton.layer.cornerRadius = 100
            profileView.profilePhotoButton.layer.masksToBounds = true
        }
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
