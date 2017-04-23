//
//  EqualizerAnimation.swift
//  Musicly
//
// Credit: https://github.com/ninjaprox/NVActivityIndicatorView

import UIKit

class AudioEqualizer {
    
    var size: CGSize?
    
    init(size: CGSize?) {
        self.size = size
    }
    
    func createLayer(for size: CGSize?, with color: UIColor?) -> CALayer? {
        let layer: CAShapeLayer? = CAShapeLayer()
        
        if let size = size, let color = color, let layer = layer {
            let roundedRect = CGRect(x: size.width,
                                     y: size.height,
                                     width: size.width,
                                     height: size.height)
            let path: UIBezierPath? = UIBezierPath(roundedRect: roundedRect,
                                                   byRoundingCorners: [.allCorners],
                                                   cornerRadii: EqualizerConstants.cornerRadii)
            layer.fillColor = color.cgColor
            layer.path = path?.cgPath
        }
        return layer
    }
    
    func setUpAnimation(in layer: CALayer?, color: UIColor?) {
        
        guard let size = size else { return }
        guard let layer = layer else { return }
        guard let color = color else { return }
        
        let lineSize = size.width / EqualizerConstants.lineSizeDenominator
        let lineDimensions = CGSize(width: lineSize, height: size.height)
        let xOffset = lineSize / EqualizerConstants.xOffsetDenominator
        let yOffset = layer.bounds.size.height - size.height
        let x = layer.bounds.size.width - xOffset
        let y = yOffset * EqualizerConstants.yMultiplier
        
        let duration: [CFTimeInterval?] = [1.4, 1, 1.7, 2, 1.2]
        let values = [0.05, 0.35, 0.12, 0.4, 0.2, 0.3, 0.15]
        
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
            
            let line = createLayer(for: lineDimensions, with: color)
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

final class IndicatorView: UIView {
    
    var color: UIColor? = .white
    var animationRect: CGRect?
    
    var animating: Bool { return isAnimating }
    private(set) public var isAnimating: Bool = false
    
    deinit {
        color = nil
     
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.clear
        isHidden = true
    }
    
    init(frame: CGRect?, color: UIColor? = nil, padding: CGFloat? = nil) {
        super.init(frame: frame!)
        guard let frame = frame else { return }
        
        let animationWidth = frame.size.width * 0.5
        let animationHeight = frame.height / 1.9
        
        animationRect = CGRect(x: frame.width,
                               y: frame.height,
                               width: animationWidth,
                               height: animationHeight)
        self.color = .white
        isHidden = true
    }
    
    final func startAnimating() {
        isHidden = false
        isAnimating = true
        layer.speed = 1
        if let animationRect = animationRect {
            let animation: AudioEqualizer? = AudioEqualizer(size: animationRect.size)
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
    
    final func setUpAnimation(animation: AudioEqualizer?) {
        if let animationRect = animationRect {
            let minEdge: CGFloat? = max(animationRect.width, animationRect.height)
            layer.sublayers = nil
            if let minEdge  = minEdge {
                self.animationRect?.size = CGSize(width: minEdge, height: minEdge)
                if let animation = animation {
                    animation.setUpAnimation(in: layer, color: color)
                }
            }
        }
    }
}
