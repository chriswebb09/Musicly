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
        let userLogin = UIButton()
        return userLogin
    }()
    
    var createAccount: UIButton = {
        let createAccount = UIButton()
        return createAccount
    }()
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupGuestUserButton(button: guestUserButton)
    }
    
    func setupGuestUserButton(button: UIButton) {
        addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: centerYAnchor, constant: UIScreen.main.bounds.height * -0.25).isActive = true
        button.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4).isActive = true
        button.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.1).isActive = true
    }
    
}
