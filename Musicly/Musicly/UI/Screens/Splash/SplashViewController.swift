//
//  SplashViewController.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 4/16/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

final class SplashViewController: UIViewController {
    
    private let splashView: SplashView? = SplashView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        edgesForExtendedLayout = []
        view.addSubview(splashView!)
        view.backgroundColor = .white
        splashView?.layoutSubviews()
    }
    
    // Animates up and down
    
    private func animateYSlow() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "transform.scale.y")
        setupSlowAnimation(animation: animation)
        return animation
    }
    
    // Animates sides
    
    private func animateXSlow() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "transform.scale.x")
        setupSlowAnimation(animation: animation)
        return animation
    }
    
    
    // Shared setup for animations
    
    private func setupSlowAnimation(animation: CABasicAnimation) {
        animation.duration = 0.3
        animation.fromValue = 1
        animation.toValue = 2
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.autoreverses = true
        animation.repeatCount = 2
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            let duration: TimeInterval = SplashConstants.animationDuration
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.splashView?.zoomAnimation() {
                    print("animating")
                }
            }
        }
        splashView?.layer.add(animateXSlow(), forKey: "animation")
        splashView?.layer.add(animateYSlow(), forKey: "animation")
        CATransaction.commit()
    }
}

