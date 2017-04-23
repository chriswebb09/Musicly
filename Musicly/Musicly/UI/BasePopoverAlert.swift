//
//  BasePopoverAlert.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 4/23/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

class BasePopoverAlert: UIView {
    public let containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.black
        containerView.layer.opacity = 0.5
        return containerView
    }()
    
    public func showPopView(viewController: UIViewController) {
        containerView.frame = UIScreen.main.bounds
        containerView.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
        viewController.view.addSubview(containerView)
    }
    
    public func hidePopView(viewController:UIViewController){
        viewController.view.sendSubview(toBack: containerView)
    }
}

