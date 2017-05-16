import UIKit

class StartViewController: UIViewController {
    
    var startView: StartView = StartView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startView.frame = UIScreen.main.bounds
        view.addSubview(startView)
        startView.layoutSubviews()
    }
}
