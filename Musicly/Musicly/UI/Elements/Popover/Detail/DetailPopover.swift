import UIKit

protocol PopDelegate: class {
    
}

final class NewPlaylistPopover: BasePopoverAlert {
    
    weak var delegate: PlaylistCreatorDelegate?
    
    var popoverState: PlaylistCreatorState = .hidden
    
    var popView: NewPlaylistView = {
        let popView = NewPlaylistView()
        popView.layer.cornerRadius = DetailPopoverConstants.cornerRadius
        popView.backgroundColor = .white
        popView.layer.borderColor = UIColor.black.cgColor
        popView.layer.borderWidth = DetailPopoverConstants.borderWidth
        popView.isUserInteractionEnabled = true
        return popView
    }()
    
    public override func showPopView(viewController: UIViewController) {
        super.showPopView(viewController: viewController)
        setupPop()
        popoverState = .enabled
        popView.frame = CGRect(x: DetailPopoverConstants.popViewFrameX,
                               y: DetailPopoverConstants.popViewFrameY,
                               width: DetailPopoverConstants.popViewFrameWidth,
                               height: DetailPopoverConstants.popViewFrameHeight)
        popView.center = CGPoint(x: UIScreen.main.bounds.midX, y: DetailPopoverConstants.popViewFrameCenterY)
        popView.clipsToBounds = true
        viewController.view.addSubview(popView)
        viewController.view.bringSubview(toFront: popView)
        popView.isHidden = true 
    }
}

extension NewPlaylistPopover: ViewPop {
  

    func setupPop() {
        popView.configureView()
    }
    
    override func hidePopView(viewController: UIViewController) {
        guard let listname = popView.playlistNameField.text else { return }
        popoverState = .hidden
        delegate?.userDidEnterPlaylistName(name: listname)
        super.hidePopView(viewController: viewController)
        popView.isHidden = true
        viewController.view.sendSubview(toBack: popView)
    }
}



