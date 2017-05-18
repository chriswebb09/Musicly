import UIKit

class LoginView: UIView {
    
    var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Login"
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    var usernameField: TextFieldExtension = {
        let usernameField = TextFieldExtension()
        usernameField.layer.borderColor = UIColor.lightGray.cgColor
        return usernameField
    }()
    
    var passwordField: TextFieldExtension = {
        let passwordField = TextFieldExtension()
        return passwordField
    }()
    
    var submitButton: UIButton = {
        let submitButton = UIButton()
        return submitButton
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .white
        setupTitleLabel(label: titleLabel)
        setupUsernameField(field: usernameField)
    }
    
    func setupTitleLabel(label: UILabel) {
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor, constant: UIScreen.main.bounds.height * -0.25).isActive = true
        label.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4).isActive = true
        label.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.1).isActive = true
    }

    
    func setupUsernameField(field: TextFieldExtension) {
        addSubview(field)
        field.translatesAutoresizingMaskIntoConstraints = false
        field.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        field.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        field.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7).isActive = true
        field.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2).isActive = true
        dump(field)
    }
    
}
