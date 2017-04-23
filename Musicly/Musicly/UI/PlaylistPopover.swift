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
        popView.layer.cornerRadius = 10
        popView.backgroundColor = UIColor.white
        popView.layer.borderColor = UIColor.black.cgColor
        popView.layer.borderWidth = 10
        popView.isUserInteractionEnabled = true
        return popView
    }()
    
    public override func showPopView(viewController: UIViewController) {
        super.showPopView(viewController: viewController)
        popView.frame = CGRect(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * -0.5, width:UIScreen.main.bounds.width * 0.93, height: UIScreen.main.bounds.height * 0.78)
        popView.center = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.height / 2.5)
        popView.clipsToBounds = true
        viewController.view.addSubview(popView)
        viewController.view.bringSubview(toFront: popView)
    }
}
