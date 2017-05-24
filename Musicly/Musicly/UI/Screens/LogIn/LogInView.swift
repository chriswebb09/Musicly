import UIKit

final class LoginView: UIView {
    
    private var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Login"
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    private var usernameField: TextFieldExtension = {
        let usernameField = TextFieldExtension()
        usernameField.placeholder = "Username"
        usernameField.layer.borderColor = UIColor.lightGray.cgColor
        usernameField.layer.borderWidth = 1
        return usernameField
    }()
    
    private var passwordField: TextFieldExtension = {
        let passwordField = TextFieldExtension()
        passwordField.placeholder = "Password"
        passwordField.layer.borderColor = UIColor.lightGray.cgColor
        passwordField.layer.borderWidth = 1
        return passwordField
    }()
    
    private var submitButton: UIButton = {
        let submitButton = UIButton()
        return submitButton
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .white
        setup(titleLabel: titleLabel)
        setup(usernamefield: usernameField)
        setup(passwordField: passwordField)
    }
    
    private func sharedLayout(view: UIView) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        view.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.1).isActive = true
        view.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7).isActive = true
    }
    
    private func setup(titleLabel: UILabel) {
        sharedLayout(view: titleLabel)
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: UIScreen.main.bounds.height * -0.25).isActive = true
    }
    
    private func setup(usernamefield: TextFieldExtension) {
        sharedLayout(view: usernameField)
        usernamefield.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
    }
    
    private func setup(passwordField: TextFieldExtension) {
        sharedLayout(view: passwordField)
        passwordField.topAnchor.constraint(equalTo: usernameField.bottomAnchor).isActive = true
    }
}
