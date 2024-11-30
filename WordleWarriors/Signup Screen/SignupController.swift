//
//  SignupController.swift
//  WordleWarriors
//
//  Created by Nishanth Gopinath on 10/22/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import CoreLocation

class SignupController: UIViewController, CLLocationManagerDelegate {
    
    let signupview = SignupView()
    let locationManager = CLLocationManager()
    var countryCode: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        view = signupview
        
        signupview.playButton.addTarget(self, action: #selector(onButtonPlayTapped), for: .touchUpInside)
        signupview.cancelButton.addTarget(self, action: #selector(onButtonCancelTapped), for: .touchUpInside)
        
        requestLocationAccess()
    }
    
    func requestLocationAccess() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        fetchCountryCode(from: location)
        locationManager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error.localizedDescription)")
        showAlert(message: "Unable to determine your location. Please try again.")
    }
    
    func fetchCountryCode(from location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("Failed to reverse geocode location: \(error.localizedDescription)")
                self.showAlert(message: "Unable to determine your country. Please try again.")
            } else if let countryCode = placemarks?.first?.isoCountryCode {
                self.countryCode = countryCode
                print("Country Code: \(countryCode)")
            }
        }
    }
    
    @objc func onButtonPlayTapped() {
        registerNewAccount()
    }
    
    @objc func onButtonCancelTapped() {
        self.navigationController?.popViewController(animated: true)
    }

    func registerNewAccount() {
        if let name = signupview.nameTextField.text,
           let email = signupview.emailTextField.text,
           let password = signupview.passwordTextField.text,
           let countryCode = self.countryCode {
            // Validate inputs
            if name.isEmpty || email.isEmpty || password.isEmpty {
                showAlert(message: "Please fill in all fields.")
                return
            }

            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                if let error = error as NSError? {
                    let errorMessage = error.localizedDescription
                    self.showAlert(message: errorMessage)
                } else if let user = result?.user {
                    // Add user to Firestore
                    self.initializeUserInFirestore(userID: user.uid, name: name, email: email, countryCode: countryCode)
                }
            }
        } else {
            showAlert(message: "Unable to determine your location. Please ensure location services are enabled.")
        }
    }
    
    func initializeUserInFirestore(userID: String, name: String, email: String, countryCode: String) {
        let db = Firestore.firestore()
        let userData: [String: Any] = [
            "name": name,
            "email": email,
            "country": countryCode,
            "totalScore": 0, // Initialize total score to 0
            "dailyWord": "", // Placeholder for daily word assignment
            "lastUpdated": FieldValue.serverTimestamp() // Set initial timestamp for daily word tracking
        ]
        
        db.collection("users").document(userID).setData(userData) { error in
            if let error = error {
                print("Error creating user in Firestore: \(error.localizedDescription)")
                self.showAlert(message: "Could not initialize user. Please try again.")
            } else {
                print("User initialized in Firestore successfully.")
                self.addUserToLeaderboard(userID: userID, name: name, countryCode: countryCode)
            }
        }
    }
    
    func addUserToLeaderboard(userID: String, name: String, countryCode: String) {
        let db = Firestore.firestore()
        let leaderboardRef = db.collection("leaderboard").document("topPlayers")

        leaderboardRef.getDocument { document, error in
            if let error = error {
                print("Error fetching leaderboard: \(error.localizedDescription)")
                return
            }

            // If the leaderboard document does not exist, create it
            if let document = document, !document.exists {
                leaderboardRef.setData([
                    "1": [
                        "userID": userID,
                        "totalScore": 0,
                        "name": name,
                        "country": countryCode
                    ]
                ]) { error in
                    if let error = error {
                        print("Error initializing leaderboard: \(error.localizedDescription)")
                    } else {
                        print("Leaderboard created and user added.")
                        self.setNameOfTheUserInFirebaseAuth(name: name)
                    }
                }
            } else {
                var nextRank = 1
                if let data = document?.data() {
                    nextRank = data.keys.count + 1
                }

                let newEntry: [String: Any] = [
                    "userID": userID,
                    "totalScore": 0,
                    "name": name,
                    "country": countryCode
                ]
                
                leaderboardRef.setData([String(nextRank): newEntry], merge: true) { error in
                    if let error = error {
                        print("Error adding user to leaderboard: \(error.localizedDescription)")
                    } else {
                        print("User added to leaderboard successfully.")
                        self.setNameOfTheUserInFirebaseAuth(name: name)
                    }
                }
            }
        }
    }
    
    func setNameOfTheUserInFirebaseAuth(name: String) {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = name
        changeRequest?.commitChanges(completion: { error in
            if let error = error as NSError? {
                let errorMessage = error.localizedDescription
                self.showAlert(message: errorMessage)
            } else {
                self.clearSignupFields()
                let homeScreen = HomeController()
                self.navigationController?.pushViewController(homeScreen, animated: true)
            }
        })
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Invalid Input", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
    }
    
    func clearSignupFields() {
        signupview.nameTextField.text = ""
        signupview.emailTextField.text = ""
        signupview.passwordTextField.text = ""
    }
}
