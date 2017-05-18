import UIKit

class StartViewController: UIViewController, StartViewDelegate {

    var startView: StartView = StartView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startView.frame = UIScreen.main.bounds
        view.addSubview(startView)
        startView.layoutSubviews()
        startView.delegate = self
    }
    
    func continueAsGuestTapped() {
        weak var appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.window?.rootViewController = TabBarController()
    }
    
    func createAccountTapped() {
        navigationController?.pushViewController(CreateAccountViewController(), animated: false)
    }
}
