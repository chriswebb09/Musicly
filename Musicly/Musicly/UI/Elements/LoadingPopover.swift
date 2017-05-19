//
//  LoadingPopover.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 5/3/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//
// 

import UIKit

final class LoadingPopover: BasePopoverAlert {

    var popView: LoadingView = {
        let popView = LoadingView()
        popView.layer.cornerRadius = DetailPopoverConstants.cornerRadius
        popView.backgroundColor = .clear
        popView.isUserInteractionEnabled = true
        return popView
    }()
    
    public override func showPopView(viewController: UIViewController) {
        super.showPopView(viewController: viewController)
        popView.frame = CGRect(x: UIScreen.main.bounds.midX,
                               y: UIScreen.main.bounds.midY,
                               width: UIScreen.main.bounds.width / 2,
                               height: UIScreen.main.bounds.height / 2)
        popView.center = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
        popView.clipsToBounds = true
        viewController.view.addSubview(popView)
        viewController.view.bringSubview(toFront: popView)
    }
}

extension LoadingPopover: ViewPop {
    weak var delegate: PopDelegate?

    func setupPop(popView: LoadingView) {
        popView.configureView()
        popView.backgroundColor = .clear
    }
    
    func showLoadingView(viewController: UIViewController) {
        setupPop(popView: popView)
        showPopView(viewController: viewController)
        popView.isHidden = false
    }
    
    
    func hideLoadingView(controller: UIViewController) {
        popView.removeFromSuperview()
        hidePopView(viewController: controller)
        controller.view.sendSubview(toBack: self)
    }
}

