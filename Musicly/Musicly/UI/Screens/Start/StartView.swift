import UIKit

class StartView: UIView {
    
    var titleLabel: UILabel = {
        let title = UILabel()
        return title
    }()
    
    var guestUserButton: UIButton = {
        let guestUser = UIButton()
        return guestUser
    }()
    
    var userLoginButton: UIButton = {
        let userLogin = BasicButtonFactory(text: "Log in to Account", textColor: .white, buttonBorderWidth: 2, buttonBorderColor: UIColor.blue.cgColor, buttonBackgroundColor: .blue)
        return userLogin.createButton()
    }()
    
    var createAccount: UIButton = {
        let createAccount = UIButton()
        return createAccount
    }()
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupTitleLabel(label: titleLabel)
        setupGuestUserButton(button: guestUserButton)
        setupUserLogin(button: userLoginButton)
        
        titleLabel.text = "Get started!"
        guestUserButton.setTitle("Continue as Guest", for: .normal)
        userLoginButton.setTitle("Log In To Account", for: .normal)
        createAccount.setTitle("Create an Account", for: .normal)
    }
    
    func setupTitleLabel(label: UILabel) {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: UIScreen.main.bounds.height * -0.25).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4).isActive = true
        titleLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.1).isActive = true
    }
    
    func setupGuestUserButton(button: UIButton) {
        addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        button.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4).isActive = true
        button.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.1).isActive = true
    }
    
    func setupUserLogin(button: UIButton) {
        addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: centerYAnchor, constant: UIScreen.main.bounds.height * 0.25).isActive = true
        button.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4).isActive = true
        button.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.1).isActive = true
    }
}
