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
            
            let path: UIBezierPath? = UIBezierPath(roundedRect: CGRect(x: size.width, y: size.height,
                                                                       width: size.width, height: size.height),
                                                   byRoundingCorners: [.allCorners],
                                                   cornerRadii: CGSize(width: 10.0, height: 10.0))
            layer.fillColor = color.cgColor
            layer.path = path?.cgPath
        }
        return layer
    }
    
    func setUpAnimation(in layer: CALayer?, color: UIColor?) {
        if let size = size,
            let layer = layer,
            let color = color {
            let lineSize: CGFloat? = size.width / 20
            
            if let lineSize = lineSize {
                let lineDimensions: CGSize? = CGSize(width: lineSize, height: size.height)
                let x: CGFloat? = layer.bounds.size.width - (lineSize / 0.043)
                let y: CGFloat? = (layer.bounds.size.height - size.height) * 5.5
                
                let duration: [CFTimeInterval?] = [1.4, 1, 1.7, 2, 1.2]
                let values = [0.05, 0.35, 0.12, 0.4, 0.2, 0.3, 0.15]
                
                for i in 0 ..< 4 {
                    
                    let animation: CAKeyframeAnimation? = CAKeyframeAnimation()
                    
                    if let animation = animation {
                        animation.keyPath = "path"
                        animation.isAdditive = true
                        animation.values = []
                        
                        for value in 0 ..< values.count {
                            let heightFactor: Double? = values[value]
                            if let heightFactor = heightFactor {
                                let height: CGFloat? = size.height * (CGFloat(heightFactor) / 1.9)
                                if let height = height {
                                    let point: CGPoint? = CGPoint(x: 0, y: size.height - (height * 0.8))
                                    if let point = point {
                                        let path: UIBezierPath? =  UIBezierPath(roundedRect: CGRect(origin: point,
                                                                                                    size: CGSize(width: lineSize, height: height * 1.45)), byRoundingCorners: [.allCorners], cornerRadii: CGSize(width: 12.0, height: 10.0))
                                        if let path = path {
                                            animation.values?.append(path.cgPath)
                                        }
                                    }
                                }
                            }
                        }
                        
                        if let timeDuration = duration[i] {
                            animation.duration = timeDuration * 1.1
                        }
                        animation.repeatCount = HUGE
                        animation.isRemovedOnCompletion = false
                        
                        if let lineDimensions = lineDimensions {
                            let line = createLayer(for: lineDimensions, with: color)
                            if let x = x, let y = y {
                                let xVal = x + lineSize * 1.9 * CGFloat(i)
                                let yVal = y * 0.45
                                let widthVal = lineSize * 2
                                let heightVal = size.height / 0.1
                                let frame: CGRect? = CGRect(x: xVal,
                                                            y: yVal,
                                                            width: widthVal,
                                                            height: heightVal)
                                if let line = line, let frame = frame {
                                    line.frame = frame
                                    line.add(animation, forKey: "animation")
                                    layer.addSublayer(line)
                                }
                            }
                        }
                    }
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
            
            self.animationRect = CGRect(x: frame.width, y: frame.height,
                                        width: frame.size.width * 0.5,
                                        height: frame.height / 1.9)
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

