//
//  LoadingView.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 4/30/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let ball = IndicatorView(frame: frame, color: .blue, padding: 40)
        addSubview(ball)
        bringSubview(toFront: ball)
        ball.startAnimating()
    }
}
