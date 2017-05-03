//
//  LoadingView.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 4/30/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    
    var ball: BallIndicatorView?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        isUserInteractionEnabled = true
        layer.borderColor = UIColor.clear.cgColor
        layer.masksToBounds = true
    }
    
    func configureView() {
        layoutSubviews()
        setupConstraints()
        backgroundColor = .clear
    }
    
    func animate() {
        ball?.startAnimating()
    }
    
    private func setupConstraints() {
        print(UIScreen.main.bounds.height)
        print(UIScreen.main.bounds.width)
        print(UIScreen.main.bounds.height - 200)
        var newFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width / 1.3, height: UIScreen.main.bounds.width)
        ball = BallIndicatorView(frame: newFrame, color: .white, padding: 100)
        addSubview(ball!)
        bringSubview(toFront: ball!)
        ball?.startAnimating()
    }
}
