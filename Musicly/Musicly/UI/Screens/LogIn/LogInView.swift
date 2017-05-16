import UIKit

class LoginView: UIView {
    
    var titleLabel: UILabel = {
        let titleLabel = UILabel()
        return titleLabel
    }()
    
    var usernameField: TextFieldExtension = {
        let usernameField = TextFieldExtension()
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
        setupTitleLabel(label: titleLabel)
    }
    
    
    func setupTitleLabel(label: UILabel) {
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
        label.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7).isActive = true
        label.heightAnchor.constraint(equalTo: heightAnchor, constant: 0.1).isActive = true
    }
    
}
