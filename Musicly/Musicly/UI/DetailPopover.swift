//
//  PlaylistPopover.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 4/23/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

final class DetailPopover: BasePopoverAlert {
    
    var popView: DetailView = {
        let popView = DetailView()
        popView.layer.cornerRadius = DetailPopoverConstants.cornerRadius
        popView.backgroundColor = .white
        popView.layer.borderColor = UIColor.black.cgColor
        popView.layer.borderWidth = DetailPopoverConstants.borderWidth
        popView.isUserInteractionEnabled = true
        return popView
    }()
    
    public override func showPopView(viewController: UIViewController) {
        super.showPopView(viewController: viewController)
        popView.frame = CGRect(x: DetailPopoverConstants.popViewFrameX,
                               y: DetailPopoverConstants.popViewFrameY,
                               width: DetailPopoverConstants.popViewFrameWidth,
                               height: DetailPopoverConstants.popViewFrameHeight)
        popView.center = CGPoint(x: UIScreen.main.bounds.midX, y: DetailPopoverConstants.popViewFrameCenterY)
        popView.clipsToBounds = true
        viewController.view.addSubview(popView)
        viewController.view.bringSubview(toFront: popView)
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
}



