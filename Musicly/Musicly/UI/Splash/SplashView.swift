//
//  SplashView.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 4/16/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

typealias completion = () -> Void

final class SplashView: UIView {
    
    var animationDuration: Double = 0.28
    
    var logoImageView: UIImageView = {
        let image = #imageLiteral(resourceName: "speakerblue")
        let imageView = UIImageView(image: image)
        return imageView
    }()
    
    // MARK: - Configure
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(logoImageView)
        logoImageView.isOpaque = true
        frame = UIScreen.main.bounds
        setupConstraints()
        backgroundColor = .white
    }
    
    private func setupConstraints() {
        addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: Logo.logoImageWidth).isActive = true
        logoImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: Logo.logoImageHeight).isActive = true
        logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        logoImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    // MARK: - Animation
    
    func zoomAnimation(_ handler: completion? = nil) {
        let duration: TimeInterval = animationDuration
        self.alpha = 0.7
        UIView.animate(withDuration: duration, animations:{ [weak self] in
            if let zoom = self?.zoomOut() {
                self?.logoImageView.transform = zoom
            }; self?.alpha = 0
            }, completion: { finished in
                DispatchQueue.main.async {
                    weak var appDelegate = UIApplication.shared.delegate as? AppDelegate
                    appDelegate?.window?.rootViewController = TabBarController()
                }
                handler?()
        })
    }
    
    private func zoomOut() -> CGAffineTransform {
        let zoomOutTranform: CGAffineTransform = CGAffineTransform(scaleX: 8, y: 18)
        return zoomOutTranform
    }
    

}

public struct Logo {
    public static let logoImageWidth = CGFloat(0.3)
    public static let logoImageHeight = CGFloat(0.1)
}
