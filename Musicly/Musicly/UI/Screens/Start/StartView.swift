import UIKit

protocol StartViewDelegate: class {
    func continueAsGuestTapped()
    func createAccountTapped()
}

class StartView: UIView {
    
    weak var delegate: StartViewDelegate?
    
    var titleLabel: UILabel = {
        let title = UILabel()
        title.textAlignment = .center
        return title
    }()
    
    var guestUserButton: UIButton = {
        let guestUser = BasicButtonFactory(text: "Continue As Guest", textColor: .white, buttonBorderWidth: 2, buttonBorderColor:UIColor.blue.cgColor, buttonBackgroundColor: .lightGray)
        return guestUser.createButton()
    }()
    
    var userLoginButton: UIButton = {
        let userLogin = LoginButtonFactory(text: "Log in to Account", textColor: .white, buttonBorderWidth: 2, buttonBorderColor: UIColor.blue.cgColor, buttonBackgroundColor: .blue)
        return userLogin.createButton()
    }()
    
    var createAccount: UIButton = {
        let createAccount = LoginButtonFactory(text: "Create Account", textColor: .white, buttonBorderWidth: 2, buttonBorderColor: UIColor.blue.cgColor, buttonBackgroundColor: .blue)
        return createAccount.createButton()
    }()
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupTitleLabel(label: titleLabel)
        setupGuestUserButton(button: guestUserButton)
        setupUserLogin(button: userLoginButton)
        setupCreatAccount(button: createAccount)
        titleLabel.text = "Get started!"
        guestUserButton.setTitle("Continue as Guest", for: .normal)
        userLoginButton.setTitle("Log In To Account", for: .normal)
        createAccount.setTitle("Create an Account", for: .normal)
        backgroundColor = .white
        createAccount.addTarget(self, action: #selector(createAccountButtonTapped), for: .touchUpInside)
        guestUserButton.addTarget(self, action: #selector(guestUserButtonTapped), for: .touchUpInside)
    }
    
    func guestUserButtonTapped() {
        delegate?.continueAsGuestTapped()
    }
    
    func createAccountButtonTapped() {
        delegate?.createAccountTapped()
    }
    
    func setupTitleLabel(label: UILabel) {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: UIScreen.main.bounds.height * -0.25).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4).isActive = true
        titleLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.1).isActive = true
    }
    
    func setupGuestUserButton(button: UIButton) {
        addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: centerYAnchor, constant: UIScreen.main.bounds.height * -0.1).isActive = true
        button.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4).isActive = true
        button.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.1).isActive = true
    }
    
    func setupUserLogin(button: UIButton) {
        addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        button.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4).isActive = true
        button.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.1).isActive = true
    }
    
    func setupCreatAccount(button: UIButton) {
        addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: centerYAnchor, constant: UIScreen.main.bounds.height * 0.25).isActive = true
        button.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4).isActive = true
        button.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.1).isActive = true
    }
}
