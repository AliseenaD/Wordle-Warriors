//
//  LeaderboardController.swift
//  WordleWarriors
//
//  Created by Nishanth Gopinath on 11/19/24.
//

import UIKit
import FirebaseFirestore

class LeaderboardController: UIViewController {
    
    let leaderboardView = LeaderboardView()
    var leaderboardData: [(rank: Int, name: String, score: Int, countryCode: String)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = leaderboardView
        
        leaderboardView.backButton.addTarget(self, action: #selector(onBackButtonTapped), for: .touchUpInside)
        leaderboardView.leaderboardTableView.dataSource = self
        leaderboardView.leaderboardTableView.delegate = self
        leaderboardView.leaderboardTableView.register(LeaderboardCell.self, forCellReuseIdentifier: "LeaderboardCell")
        
        fetchLeaderboardData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
    }
    
    @objc private func onBackButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func fetchLeaderboardData() {
        let db = Firestore.firestore()
        let leaderboardRef = db.collection("leaderboard").document("topPlayers")
        
        leaderboardRef.getDocument { [weak self] document, error in
            guard let self = self, let document = document, document.exists, let data = document.data() else {
                print("Error fetching leaderboard: \(error?.localizedDescription ?? "No data")")
                return
            }
            
            var leaderboard: [(rank: Int, name: String, score: Int, countryCode: String)] = []
            
            // Parse leaderboard data
            for (key, value) in data {
                if let position = Int(key),
                   let playerData = value as? [String: Any],
                   let name = playerData["name"] as? String,
                   let score = playerData["totalScore"] as? Int,
                   let countryCode = playerData["country"] as? String {
                    leaderboard.append((rank: position, name: name, score: score, countryCode: countryCode))
                }
            }
            
            // Sort leaderboard by score descending
            leaderboard.sort { $0.score > $1.score }
            self.leaderboardData = leaderboard.enumerated().map { (index, entry) in
                (rank: index + 1, name: entry.name, score: entry.score, countryCode: entry.countryCode)
            }
            
            // Reload table data on main thread
            DispatchQueue.main.async {
                self.leaderboardView.leaderboardTableView.reloadData()
            }
        }
    }
}

// MARK: - UITableView DataSource and Delegate
extension LeaderboardController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leaderboardData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LeaderboardCell", for: indexPath) as? LeaderboardCell else {
            return UITableViewCell()
        }
        let entry = leaderboardData[indexPath.row]
        cell.configure(rank: entry.rank, name: entry.name, score: entry.score, countryCode: entry.countryCode)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
