//
//  ProfileViewController.swift
//  WordleWarriors
//
//  Created by Nishanth Gopinath on 11/16/24.
//

import UIKit
import FirebaseStorage
import FirebaseAuth
import FirebaseFirestore

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let profileView = ProfileView()
    private let loadingSpinner = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()
        view = profileView

        profileView.backButton.addTarget(self, action: #selector(onBackButtonTapped), for: .touchUpInside)
        profileView.profilePhotoButton.addTarget(self, action: #selector(onProfilePhotoTapped), for: .touchUpInside)
        setupLoadingIndicator()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
        fetchProfileImage()
    }
    
    private func setupLoadingIndicator() {
        loadingSpinner.color = .gray
        loadingSpinner.translatesAutoresizingMaskIntoConstraints = false
        profileView.addSubview(loadingSpinner)
        NSLayoutConstraint.activate([
            loadingSpinner.centerXAnchor.constraint(equalTo: profileView.profilePhotoButton.centerXAnchor),
            loadingSpinner.centerYAnchor.constraint(equalTo: profileView.profilePhotoButton.centerYAnchor)
        ])
        loadingSpinner.startAnimating()
        profileView.profilePhotoButton.isHidden = true
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

    private func uploadProfileImage(_ image: UIImage, completion: @escaping (URL?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("Error: User is not authenticated")
            completion(nil)
            return
        }

        let storageRef = Storage.storage().reference().child("profile_images/\(userId).jpg")
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("Error: Unable to compress image")
            completion(nil)
            return
        }

        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        storageRef.putData(imageData, metadata: metadata) { metadata, error in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
                completion(nil)
                return
            }

            storageRef.downloadURL { url, error in
                if let error = error {
                    print("Error getting download URL: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                if let url = url {
                    self.saveImageUrl(url)
                }
                completion(url)
            }
        }
    }

    private func saveImageUrl(_ url: URL) {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        let db = Firestore.firestore()
        db.collection("users").document(userId).setData(["profileImageUrl": url.absoluteString], merge: true) { error in
            if let error = error {
                print("Error saving image URL to Firestore: \(error.localizedDescription)")
            } else {
                print("Image URL successfully saved to Firestore")
            }
        }
    }

    private func fetchProfileImage() {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        let db = Firestore.firestore()
        db.collection("users").document(userId).getDocument { document, error in
            if let error = error {
                print("Error fetching profile image URL: \(error.localizedDescription)")
                self.loadingSpinner.stopAnimating()
                self.profileView.profilePhotoButton.isHidden = false
                return
            }

            if let document = document, let data = document.data(),
               let imageUrlString = data["profileImageUrl"] as? String,
               let imageUrl = URL(string: imageUrlString) {
                self.loadImage(from: imageUrl)
            } else {
                self.loadingSpinner.stopAnimating()
                self.profileView.profilePhotoButton.isHidden = false
            }
        }
    }

    private func loadImage(from url: URL) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.profileView.profilePhotoButton.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
                    self.profileView.profilePhotoButton.layer.cornerRadius = 100
                    self.profileView.profilePhotoButton.layer.masksToBounds = true
                    self.loadingSpinner.stopAnimating()
                    self.profileView.profilePhotoButton.isHidden = false
                }
            } else {
                DispatchQueue.main.async {
                    self.loadingSpinner.stopAnimating()
                    self.profileView.profilePhotoButton.isHidden = false
                }
            }
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let selectedImage = info[.editedImage] as? UIImage {
            // Update UI with selected image
            profileView.profilePhotoButton.setImage(selectedImage.withRenderingMode(.alwaysOriginal), for: .normal)
            profileView.profilePhotoButton.layer.cornerRadius = 100
            profileView.profilePhotoButton.layer.masksToBounds = true
            
            // Upload image to Firebase Storage
            uploadProfileImage(selectedImage) { url in
                guard let url = url else {
                    print("Failed to upload image")
                    return
                }
                print("Uploaded profile image, URL: \(url)")
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
