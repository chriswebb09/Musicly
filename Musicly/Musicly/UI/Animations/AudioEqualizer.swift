//
//  AudioEqualizer.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 4/29/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

final class AudioEqualizer {
    
    var size: CGSize
    
    init(size: CGSize) {
        self.size = size
    }
    
    func createLayer(for size: CGSize, with color: UIColor) -> CALayer? {
        let layer: CAShapeLayer? = CAShapeLayer()
        let roundedRect = CGRect(x: size.width,
                                 y: size.height,
                                 width: size.width,
                                 height: size.height)
        let path: UIBezierPath? = UIBezierPath(roundedRect: roundedRect,
                                               byRoundingCorners: [.allCorners],
                                               cornerRadii: EqualizerConstants.cornerRadii)
        layer?.fillColor = color.cgColor
        layer?.path = path?.cgPath
        
        return layer
    }
    
    func setUpAnimation(in layer: CALayer, color: UIColor) {
        
        let lineSize = size.width / EqualizerConstants.lineSizeDenominator
        let lineDimensions = CGSize(width: lineSize, height: size.height)
        let xOffset = lineSize / EqualizerConstants.xOffsetDenominator
        let yOffset = layer.bounds.size.height - size.height
        let x = layer.bounds.size.width - xOffset
        let y = yOffset * EqualizerConstants.yMultiplier
        
        let duration: [CFTimeInterval?] = [1.2, 1.5, 1.7, 2, 1.6]
        let values = [0.1, 0.13, 0.35, 0.12, 0.4, 0.2, 0.01, 0.14, 0.3, 0.15]
        
        for i in 0 ..< 4 {
            
            let animation = CAKeyframeAnimation()
            animation.keyPath = "path"
            animation.isAdditive = true
            animation.values = []
            
            for value in 0 ..< values.count {
                
                let heightFactor =  values[value]
                let heightOffset = CGFloat(heightFactor) / EqualizerConstants.heightOffsetDenominator
                let height = size.height * heightOffset
                let pointOffset =  height * EqualizerConstants.pointOffsetMultiplier
                let point = CGPoint(x: 0, y: size.height - pointOffset)
                
                let roundRect = CGRect(origin: point,
                                       size: CGSize(width: lineSize,
                                                    height: height * 1.45))
                
                let path: UIBezierPath? =  UIBezierPath(roundedRect: roundRect,
                                                        byRoundingCorners: [.allCorners],
                                                        cornerRadii: EqualizerConstants.cornerRadii)
                if let path = path {
                    animation.values?.append(path.cgPath)
                }
                
                
            }
            
            if let timeDuration = duration[i] {
                animation.duration = timeDuration * EqualizerConstants.durationMultiplier
            }
            
            animation.repeatCount = HUGE
            animation.isRemovedOnCompletion = false
            
            let line = createLayer(for: lineDimensions, with: UIColor(red:0.21, green:0.64, blue:0.82, alpha:1.0))
            let xVal = x + lineSize * EqualizerConstants.xValMultiplier * CGFloat(i)
            let yVal = y * EqualizerConstants.yValMutliplier
            let widthVal = lineSize * EqualizerConstants.widthValMultiplier
            let heightVal = size.height / EqualizerConstants.heightValMultiplier
            let frame = CGRect(x: xVal,
                               y: yVal,
                               width: widthVal,
                               height: heightVal)
            if let line = line {
                line.frame = frame
                line.add(animation, forKey: "animation")
                layer.addSublayer(line)
            }
        }
    }
}
