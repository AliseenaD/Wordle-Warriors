//
//  GameBoardView.swift
//  WordleWarriors
//
//  Created by Ali daeihagh on 10/28/24.
//

import UIKit

class GameBoardView: UIView {
    
    // Define board length and max attempts for the grid
    let wordLength = 5
    let maxAttempts = 6
    
    var tiles: [[UILabel]] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .darkGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Setup the grid for the board
    func setupBoard() {
        // Define tile and spacing sizes
        let spacing: CGFloat = 5
        let tileSize = (frame.width - CGFloat(wordLength - 1) * spacing) / CGFloat(wordLength)
        
        // Setup the grid view by iterating throw number of rows
        for row in 0..<maxAttempts {
            var rowTiles: [UILabel] = []
            
            // Instantiate a new tile for each col
            for col in 0..<wordLength {
                let tile = UILabel()
                tile.translatesAutoresizingMaskIntoConstraints = false
                tile.backgroundColor = .systemGray6
                tile.textAlignment = .center
                tile.font = .systemFont(ofSize: 28, weight: .bold)
                tile.layer.borderWidth = 5
                tile.layer.borderColor = UIColor.systemGray4.cgColor
                
                // Must create a constraint for each individual tile
                NSLayoutConstraint.activate([
                    tile.widthAnchor.constraint(equalToConstant: tileSize),
                    tile.heightAnchor.constraint(equalToConstant: tileSize),
                    tile.leadingAnchor.constraint(equalTo: leadingAnchor, constant: CGFloat(col) * (tileSize + spacing)),
                    tile.topAnchor.constraint(equalTo: topAnchor, constant: CGFloat(row) * (tileSize + spacing))
                ])
                
                self.addSubview(tile)
                // Add the tile to the row
                rowTiles.append(tile)
            }
            
            tiles.append(rowTiles)
        }
    }
}
