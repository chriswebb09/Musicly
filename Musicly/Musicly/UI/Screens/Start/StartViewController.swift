import UIKit

class StartViewController: UIViewController {
    
    let startView = StartView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startView.frame = UIScreen.main.bounds
        view.addSubview(startView)
        startView.layoutSubviews()
    }
}
