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
            
            let path = UIBezierPath(roundedRect: CGRect(x: size.width * 2,
                                                        y: size.height / 1.2,
                                                        width: size.width / 2, height: size.height),
                                    byRoundingCorners: [.allCorners],
                                    cornerRadii: CGSize(width: 10.0, height: 10.0))
            layer.fillColor = color.cgColor
            layer.path = path.cgPath
        }
        return layer
    }
    
    func setUpAnimation(in layer: CALayer?, color: UIColor?) {
        if let size = size, let layer = layer, let color = color {
            
            
            let lineSize = size.width / 10
            let x = (layer.bounds.size.width - lineSize * 6.5) / 1.8
            let y = (layer.bounds.size.height - size.height) * 5
            let duration: [CFTimeInterval] = [1.6, 1.5, 1.4, 2]
            let values = [0, 0.2, 0.25, 0.05, 0.2, 0.3, 0.15]
            
            for i in 0 ..< 4 {
                let animation = CAKeyframeAnimation()
                
                animation.keyPath = "path"
                animation.isAdditive = true
                animation.values = []
                
                for value in 0 ..< values.count {
                    let heightFactor = values[value]
                    let height = size.height * (CGFloat(heightFactor) / 1.5)
                    let point = CGPoint(x: 0, y: size.height - (height * 0.8))
                    
                    let path =  UIBezierPath(roundedRect: CGRect(origin: point, size: CGSize(width: lineSize, height: height / 2)), byRoundingCorners: [.allCorners], cornerRadii: CGSize(width: 12.0, height: 10.0))
                    
                    animation.values?.append(path.cgPath)
                }
                
                animation.duration = duration[i]
                animation.repeatCount = HUGE
                animation.isRemovedOnCompletion = false
                
                let lineDimensions = CGSize(width: lineSize, height: size.height)
                let line = createLayer(for: lineDimensions, with: color)
                let frame = CGRect(x: x + lineSize * 1.1 * CGFloat(i),
                                   y: y * 0.4,
                                   width: lineSize,
                                   height: size.height * 7)
                if let line = line {
                    line.frame = frame
                    line.add(animation, forKey: "animation")
                    layer.addSublayer(line)
                }
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
        
        print("indicator deallocated")
        dump(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.clear
        isHidden = true
    }
    
    init(frame: CGRect?, color: UIColor? = nil, padding: CGFloat? = nil, animationRect: CGRect? = nil) {
        super.init(frame: frame!)
        if let frame = frame {
            self.animationRect = CGRect(x: self.frame.width * 0.01,
                                        y: self.frame.height / 1.6,
                                        width: frame.size.width * 0.3,
                                        height: frame.height / 1.8)
            self.color = .white
            isHidden = true
        }
        
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
            let minEdge = max(animationRect.width, animationRect.height)
            layer.sublayers = nil
            self.animationRect?.size = CGSize(width: minEdge, height: minEdge)
            if let animation = animation {
                animation.setUpAnimation(in: layer, color: color)
            }
            
        }
        
    }
}

