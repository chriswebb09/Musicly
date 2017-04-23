//
//  PlaylistPopover.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 4/23/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

class DetailPopover: BasePopoverAlert {
    
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
                               width:DetailPopoverConstants.popViewFrameWidth,
                               height: DetailPopoverConstants.popViewFrameHeight)
        popView.center = CGPoint(x: UIScreen.main.bounds.midX, y: DetailPopoverConstants.popViewFrameCenterY)
        popView.clipsToBounds = true
        viewController.view.addSubview(popView)
        viewController.view.bringSubview(toFront: popView)
    }
}

struct DetailPopoverConstants {
    static let cornerRadius: CGFloat = 10
    static let borderWidth: CGFloat = 10
    static let popViewFrameX: CGFloat = UIScreen.main.bounds.width * 0.5
    static let popViewFrameY: CGFloat = UIScreen.main.bounds.height * -0.5
    static let popViewFrameWidth: CGFloat = UIScreen.main.bounds.width * 0.93
    static let popViewFrameHeight: CGFloat = UIScreen.main.bounds.height * 0.78
    static let popViewFrameCenterY: CGFloat = UIScreen.main.bounds.height / 2.5
}
