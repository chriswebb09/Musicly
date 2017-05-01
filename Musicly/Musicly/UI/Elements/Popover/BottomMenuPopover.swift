//
//  BottomMenuPopover.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 4/30/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//


import UIKit

final class BottomMenuPopover: BasePopoverAlert {
    
    var popView: MenuView = {
        let popView = MenuView()
        popView.backgroundColor = .black
        popView.isUserInteractionEnabled = true
        return popView
    }()
    
    public override func showPopView(viewController: UIViewController) {
        super.showPopView(viewController: viewController)
        popView.frame = CGRect(x: viewController.view.bounds.width,
                               y: viewController.view.bounds.height,
                               width: viewController.view.bounds.width,
                               height: viewController.view.bounds.height * 0.45)
        popView.center = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.height * 0.795)
        popView.clipsToBounds = true
        viewController.view.addSubview(popView)
        viewController.view.bringSubview(toFront: popView)
    }
    
    func setupPop() {
        popView.configureView()
        popView.layer.borderWidth = 1.5
    }
}

