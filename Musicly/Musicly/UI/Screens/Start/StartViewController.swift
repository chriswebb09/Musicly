import UIKit

protocol StartViewControllerDelegate: class {
    func continueAsGuestSelected()
    func createAccountSelected()
    func loginSelected()
}

class StartViewController: UIViewController, StartViewDelegate {

    var startView: StartView = StartView()
    
    weak var delegate: StartViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startView.frame = UIScreen.main.bounds
        view.addSubview(startView)
        startView.layoutSubviews()
        startView.delegate = self
    }
    
    func continueAsGuestTapped() {
        delegate?.continueAsGuestSelected()
        weak var appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.window?.rootViewController = TabBarController()
    }
    
    func createAccountTapped() {
        navigationController?.pushViewController(CreateAccountViewController(), animated: false)
    }
    
    func loginTapped() {
        navigationController?.pushViewController(LoginViewController(), animated: false)
    }
}
