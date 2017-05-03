//
//  BallAnimationView.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 5/2/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

final class BallIndicatorView: UIView {
    
    var color: UIColor? = .blue
    
    var animationRect: CGRect?
    
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
        
        
        
        let animationWidth = frame.size.width * 0.2
        let animationHeight = frame.height * 0.2
        animationRect = CGRect(x: frame.size.width / 1000,
                               y: frame.height * 0.2,
                               width: animationWidth,
                               height: animationHeight)
        self.color = UIColor(red:0.03, green:0.57, blue:0.82, alpha:1.0)
        isHidden = true
    }
    
    final func startAnimating() {
        isHidden = false
        isAnimating = true
        layer.speed = 1
        if let animationRect = animationRect {
            let animation: BallAnimation? = BallAnimation(size: animationRect.size)
            if let animation = animation {
                setUpAnimation(animation: animation)
            }
        }
    }
    
    final func stopAnimating() {
        isHidden = true
        isAnimating = false
        layer.sublayers?.removeAll()
    }
    
    final func setUpAnimation(animation: BallAnimation?) {
        if let animationRect = animationRect {
            let minEdge: CGFloat? = max(animationRect.width, animationRect.height)
            layer.sublayers = nil
            if let minEdge  = minEdge {
                self.animationRect?.size = CGSize(width: minEdge, height: minEdge)
                if let animation = animation {
                    animation.setUpAnimation(in: layer, size: CGSize(width: minEdge / 4, height: minEdge / 4), color: color!)
                    //animation.setUpAnimation(in: layer, color: color!)
                }
            }
        }
    }
}
