import UIKit

class MainView: UIView {
    
    private let gradientLayer = CAGradientLayer()
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let wordGridImageView = UIImageView()
    let loginButton = UIButton(type: .system)
    let signUpButton = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient()
        setupContainerView()
        setupTitleLabel()
        setupWordGrid()
        setupLoginButton()
        setupSignUpButton()

        initConstraints()
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
    
    //setup grey box
    private func setupContainerView() {
        containerView.backgroundColor = UIColor(white: 0.0, alpha: 0.2)
        containerView.layer.cornerRadius = 20
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
    }
    
    //setup title
    private func setupTitleLabel() {
        titleLabel.text = "WordleWarriors"
        titleLabel.font = UIFont(name: "AvenirNext-Bold", size: 34)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
    }
    
    //setup image
    private func setupWordGrid() {
        wordGridImageView.image = UIImage(named: "logo.png")
        wordGridImageView.contentMode = .scaleAspectFit
        wordGridImageView.layer.cornerRadius = 20
        wordGridImageView.layer.masksToBounds = true
        wordGridImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(wordGridImageView)
    }
    
    //setup login
    private func setupLoginButton() {
        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.backgroundColor = UIColor(red: 102/255, green: 217/255, blue: 178/255, alpha: 1.0)
        loginButton.layer.cornerRadius = 20
        loginButton.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 20)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(loginButton)
    }
    
    //setup sign up
    private func setupSignUpButton() {
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.setTitleColor(.white, for: .normal)
        signUpButton.backgroundColor = UIColor(red: 255/255, green: 176/255, blue: 59/255, alpha: 1.0)
        signUpButton.layer.cornerRadius = 20
        signUpButton.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 20)
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(signUpButton)
    }


    func initConstraints(){
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 175),
            containerView.widthAnchor.constraint(equalToConstant: 300),
            containerView.heightAnchor.constraint(equalToConstant: 450),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 30),
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            wordGridImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            wordGridImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            wordGridImageView.widthAnchor.constraint(equalToConstant: 150),
            wordGridImageView.heightAnchor.constraint(equalToConstant: 150),
            
            loginButton.topAnchor.constraint(equalTo: wordGridImageView.bottomAnchor, constant: 20),
            loginButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            loginButton.widthAnchor.constraint(equalToConstant: 250),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            
            signUpButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 10),
            signUpButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            signUpButton.widthAnchor.constraint(equalToConstant: 250),
            signUpButton.heightAnchor.constraint(equalToConstant: 50)
        ])

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
