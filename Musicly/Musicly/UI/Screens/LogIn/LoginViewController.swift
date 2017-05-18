import UIKit

class LoginViewController: UIViewController {
    
    let loginView = LoginView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginView.frame = UIScreen.main.bounds
        loginView.layoutSubviews()
        view.addSubview(loginView)
        dump(loginView.usernameField.bounds)
    }
    
}
