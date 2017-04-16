//
//  SplashViewController.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 4/16/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

final class SplashViewController: UIViewController {
    
    let splashView = SplashView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        edgesForExtendedLayout = []
        view.addSubview(splashView)
        view.backgroundColor = .white
        splashView.layoutSubviews()
    }
    
    func animateYSlow() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "transform.scale.y")
        animation.duration = 0.3
        animation.fromValue = 1
        animation.toValue = 1.4
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.autoreverses = true
        animation.repeatCount = 2
        return animation
    }
    
    func animateXSlow() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "transform.scale.x")
        animation.duration = 0.2
        animation.fromValue = 1
        animation.toValue = 1.6
        //kCAMediaTimingFunctionLinear
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.autoreverses = true
        animation.repeatCount = 3
        return animation
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        CATransaction.begin()
        var animationDuration: Double = 0.04
        CATransaction.setCompletionBlock {
            let duration: TimeInterval = animationDuration * 0.005
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [unowned self] in
                self.splashView.zoomAnimation() {
                    print("animating")
                }
            }
        }
        
        
        let animateXSlow = self.animateXSlow()
        let animateYSlow = self.animateYSlow()
        
        self.splashView.layer.add(animateXSlow, forKey: nil)
        self.splashView.layer.add(animateYSlow, forKey: nil)
        CATransaction.commit()
    }
    
}
