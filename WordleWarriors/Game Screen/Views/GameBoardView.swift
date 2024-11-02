import UIKit

class GameBoardView: UIView {
    
    private let gradientLayer = CAGradientLayer()
    let wordLength = 5
    let maxAttempts = 6
    var tiles: [[UILabel]] = []
    let backButton = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .darkGray
        setupGradient()
        setupBackButton()
        setupBoard()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupGradient() {
        gradientLayer.colors = [
            UIColor(red: 65/255, green: 176/255, blue: 171/255, alpha: 1.0).cgColor,
            UIColor(red: 149/255, green: 229/255, blue: 182/255, alpha: 1.0).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func setupBackButton() {
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(.white, for: .normal)
        backButton.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        backButton.tintColor = .white
        backButton.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 20)
        backButton.semanticContentAttribute = .forceLeftToRight
        backButton.contentHorizontalAlignment = .left
        backButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backButton)
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 5),
            backButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            backButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
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
        
        let tileSize: CGFloat = 50
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
