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
    
    func createLayer(with color: UIColor) -> CALayer? {
        let layer: CAShapeLayer? = CAShapeLayer()
        
        layer?.fillColor = color.cgColor
        return layer
    }
    
    func setUpAnimation(in layer: CALayer, color: UIColor) {
        
        let lineSize = (size.width * 0.05) / EqualizerConstants.lineSizeDenominator
        let xOffset = (lineSize * 9.5) / EqualizerConstants.xOffsetDenominator
        let yOffset = layer.bounds.size.height - size.height
        let x = layer.bounds.size.width - xOffset
        let y = yOffset * EqualizerConstants.yMultiplier
        
        let duration: [CFTimeInterval?] = [6, 5.5, 7.5, 9.5, 14.4, 13.5, 7.3, 6.5, 8, 6, 5.5, 6.5, 6.8, 7, 8, 5.5, 6, 8.5, 9.3, 8, 6, 15, 7.5, 8.5, 4, 13.5, 9.3, 6.5, 8, 6, 5.5, 4.5, 7.5, 5, 8, 6, 8.5, 5, 14.5, 9, 5.5, 6.3, 14.5, 8, 6, 7.5, 5, 7.5, 5, 9.5, 5, 4.5, 14, 13.5, 7, 4.5, 6, 6, 5.5, 5, 4.5, 6.4, 3, 5.5, 5, 6, 8.5, 5, 9.5, 6.3, 5, 7, 8.5, 9.2, 6, 5, 9.7, 5.5, 6.5, 5.5, 3.5, 6.5, 13.5, 8, 6, 5.5, 6.5, 4.5, 14, 3.5, 7.3, 8.5, 2, 6, 5.5, 5, 4.5, 4, 13.5, 3, 12.5, 8, 6, 8.5, 5, 4.5, 14, 17.5, 7.3, 5, 6, 5, 4.5, 14, 3.5, 7, 5.5, 9, 6, 5.5, 5, 4.5, 4, 3.5, 3, 2.5, 8, 6, 5.5, 5, 4.5, 4, 3.5, 3, 6.5, 8, 6, 8.5, 5, 4.5, 4, 3.5, 13, 12.5, 5.5, 5, 9 ,6, 5.5, 5, 4.5, 4, 3.5, 6, 12.5, 6, 5.5, 5, 4.5, 14, 3.5, 3, 2.5, 2, 6, 5.5, 7.5, 9.5, 14.4, 13.5, 13, 6.5, 8, 6, 5.5, 6.5, 6.8, 7, 8, 5.5, 6, 8.5, 9.3, 8, 6, 5, 7.5, 8.5, 4, 3.5, 3, 2.5, 8, 6, 5.5, 4.5, 13.5, 5, 8, 6, 8.5, 5, 4.5, 4, 5.5, 3, 4.5, 8, 6, 7.5, 5, 7.5, 5, 9.5, 5, 4.5, 4, 13.5, 3, 2.5, 2, 6, 5.5, 5, 4.5, 6.4, 13, 5.5, 15, 6, 8.5, 5, 9.5, 13, 5, 7, 8.5, 9.2, 6, 5, 9.7, 5.5, 6.5, 5.5, 13.5, 6.5, 3.5, 8, 6, 5.5, 6.5, 4.5, 4, 13.5, 3, 12.5, 12, 6, 5.5, 5, 4.5, 4, 13.5]
        
       
        
        let values = [0.01, 0.06, 0.06, 0.18, 0.2, 0.2, 0.06, 0.2 ,0.06 , 0.0, 0.0, 0.2, 0.06, 0.18, 0.32, 0.08, 0, 0.08 ,0.08 ,0.06, 0.01, 0.06, 0.06, 0.18, 0.02, 0.18, 0.3, 0.06, 0.08 ,0.15, 0.1, 0.05, 0.08, 0.06, 0.02, 0.08, 0.01, 0.06 ,0.06 ,0.08, 0.05, 0.01, 0.15, 0.08, 0.2, 0.18, 0.1, 0.08 ,0.01 ,0.14, 0.07, 0.0, 0.01, 0.18, 0.08, 0.04, 0.02, 0.01 ,0.02 ,0.02, 0.21, 0.0, 0.06, 0.18, 0.32, 0.2, 0.06, 0.2 ,0.06 , 0.01, 0.01, 0.02, 0.06, 0.18, 0.2, 0.18, 0, 0.01 ,0.01 ,0.06, 0.01, 0.06, 0.06, 0.18, 0.02, 0.08, 0.03, 0.06, 0.08 ,0.05, 0.1, 0.15, 0.08, 0.18, 0.2, 0.18, 0.01, 0.06 ,0.06 ,0.08, 0.25, 0.01, 0.15]
                      
        
        for i in 0 ..< 235 {
            
            let animation = CAKeyframeAnimation()
            animation.keyPath = "path"
            animation.isAdditive = true
            animation.values = []
            
            for value in 0..<values.count {
                
                let heightFactor =  values[value]
                let heightOffset = CGFloat(heightFactor) / EqualizerConstants.heightOffsetDenominator
                let height = size.height * heightOffset
                let pointOffset =  height * EqualizerConstants.pointOffsetMultiplier
                let point = CGPoint(x: 0, y: size.height - pointOffset)
                
                let roundRect = CGRect(origin: point,
                                       size: CGSize(width: lineSize * 0.8,
                                                    height: height * 2.6))
                
                let path: UIBezierPath? =  UIBezierPath(roundedRect: roundRect,
                                                        byRoundingCorners: [],
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
            let line = createLayer(with: .white)
            let xVal = x + lineSize * EqualizerConstants.xValMultiplier * CGFloat(i) * 0.5
            let yVal = y * EqualizerConstants.yValMutliplier * 0.9
            let widthVal = lineSize * EqualizerConstants.widthValMultiplier * 2
            let heightVal = size.height / EqualizerConstants.heightValMultiplier * 1.5
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
