//
//  PlaylistPopover.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 4/23/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

enum PlaylistCreatorState {
    case enabled, hidden
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
    
    func setupPop() {
        popView.configureView()
        guard let popTitle = popView.doneButton.titleLabel else { return }
        popView.backgroundColor = CollectionViewAttributes.backgroundColor
        popView.doneButton.setTitleColor(PlaylistViewControllerConstants.mainColor, for: .normal)
        popTitle.font = UIFont(name: "Avenir-Book", size: 20)!
        popView.doneButton.setTitle("Done", for: .normal)
        popView.doneButton.layer.borderColor = PlaylistViewControllerConstants.mainColor.cgColor
        popView.doneButton.layer.borderWidth = 1.5
        popView.layer.borderWidth = 1.5
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



