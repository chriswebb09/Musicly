//
//  BallAnimationView.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 5/2/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//
// Credit: NVActivityIndicatorView

import UIKit

final class BallIndicatorView: UIView {
    
    var color: UIColor? = .blue
    
    var animationRect: CGRect?
    var padding: CGFloat = 20
    
    var animating: Bool { return isAnimating }
    
    private(set) public var isAnimating: Bool = false {
        didSet {
            print("Animating \(isAnimating)")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        isHidden = true
    }
    
    init(frame: CGRect?, color: UIColor? = nil, padding: CGFloat? = nil) {
        super.init(frame: frame!)
        guard let frame = frame else { return }
        let animationWidth = frame.size.width * 0.5
        let animationHeight = frame.height * 0.4
        animationRect = CGRect(x: frame.size.width,
                               y: frame.size.height,
                               width: animationWidth,
                               height: animationHeight)
        self.padding = padding!
        self.color = color
        isHidden = true
    }
    
    final func startAnimating() {
        isHidden = false
        isAnimating = true
        layer.speed = 1
        if let animationRect = animationRect {
            let animation: BallAnimation? = BallAnimation(size: animationRect.size)
            if let animation = animation {
                setUpAnimation(ballAnimation: animation)
            }
        }
    }
    
    final func stopAnimating() {
        isHidden = true
        isAnimating = false
        layer.sublayers?.removeAll()
    }

    
    private final func setUpAnimation(ballAnimation: BallAnimation) {
        let animationType: AnimationDelegate = ballAnimation
        var animationRect: CGRect = UIEdgeInsetsInsetRect(frame, UIEdgeInsetsMake(padding / 3, padding / 3, padding / 3, padding / 3))
        let minEdge = min(animationRect.width, animationRect.height)
        
        layer.sublayers = nil
        animationRect.size = CGSize(width: minEdge, height: minEdge)
        animationType.setUpAnimation(in: layer, size: animationRect.size, color: color!)
    }
}
