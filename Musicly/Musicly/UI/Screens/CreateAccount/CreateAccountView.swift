import UIKit

protocol CreateAccountDelegate: class {
    func createAcccount(with username: String, email: String, password: String)
}

class CreateAccountView: UIView {
    
    weak var delegate: CreateAccountDelegate?
    
    var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Create Your Account"
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    var usernameField: TextFieldExtension = {
        let usernameField = TextFieldExtension()
        return usernameField
    }()
    
    var emailField: TextFieldExtension = {
        let emailField = TextFieldExtension()
        return emailField
    }()
    
    var passwordField: TextFieldExtension = {
        let passwordField = TextFieldExtension()
        return passwordField
    }()
    
    var confirmPasswordField: TextFieldExtension = {
        let confirmPasswordField = TextFieldExtension()
        return confirmPasswordField
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .white
        setupTitleLabel(label: titleLabel)
    }
    
    func setupTitleLabel(label: UILabel) {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: UIScreen.main.bounds.height * -0.25).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4).isActive = true
        titleLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.1).isActive = true
    }
    
}
