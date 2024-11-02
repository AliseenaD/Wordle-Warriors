//
//  GameBoardView.swift
//  WordleWarriors
//
//  Created by Ali daeihagh on 10/28/24.
//

import UIKit

class GameBoardView: UIView {
    
    private let gradientLayer = CAGradientLayer()
    // Define board length and max attempts for the grid
    let wordLength = 5
    let maxAttempts = 6
    var tiles: [[UILabel]] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .darkGray
        setupGradient()
        setupBoard()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //setup background
    private func setupGradient() {
        gradientLayer.colors = [
            UIColor(red: 65/255, green: 176/255, blue: 171/255, alpha: 1.0).cgColor,
            UIColor(red: 149/255, green: 229/255, blue: 182/255, alpha: 1.0).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    // Setup the grid for the board using a vertical stack
    func setupBoard() {
        let boardStackView = UIStackView()
        boardStackView.axis = .vertical
        boardStackView.alignment = .center
        boardStackView.spacing = 5
        boardStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(boardStackView)
        
        NSLayoutConstraint.activate([
            boardStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            boardStackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        let tileSize: CGFloat = 50  // tile size defined explicitly here
        for _ in 0..<maxAttempts {
            var rowTiles: [UILabel] = []
            let rowStackView = UIStackView()
            rowStackView.axis = .horizontal
            rowStackView.alignment = .center
            rowStackView.spacing = 5
            
            for _ in 0..<wordLength {
                let tile = UILabel()
                tile.translatesAutoresizingMaskIntoConstraints = false
                tile.backgroundColor = .systemGray6
                tile.textAlignment = .center
                tile.font = .systemFont(ofSize: 28, weight: .bold)
                tile.layer.borderWidth = 5
                tile.layer.borderColor = UIColor.systemGray4.cgColor
                tile.widthAnchor.constraint(equalToConstant: tileSize).isActive = true
                tile.heightAnchor.constraint(equalToConstant: tileSize).isActive = true
                
                rowStackView.addArrangedSubview(tile)
                rowTiles.append(tile)
            }
            
            tiles.append(rowTiles)
            boardStackView.addArrangedSubview(rowStackView)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
}
