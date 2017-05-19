//
//  SplashView.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 4/16/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

typealias completion = () -> Void

protocol SplashViewDelegate: class {
    func animationHasCompleted()
}

final class SplashView: UIView {
    
    weak var delegate: SplashViewDelegate?
    
    var animationDuration: Double = 0.5
    
    var logoImageView: UIImageView = {
        let image = #imageLiteral(resourceName: "speakerblue")
        let imageView = UIImageView(image: image)
        imageView.isHidden = true
        return imageView
    }()
    
    var speakerZero: UIImageView = {
        let image = #imageLiteral(resourceName: "speakerblue-0")
        let imageView = UIImageView(image: image)
        return imageView
    }()
    
    
    // MARK: - Configure
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(logoImageView)
        logoImageView.isOpaque = true
        frame = UIScreen.main.bounds
        setupConstraints(logoImageView: logoImageView)
        backgroundColor = .white
    }
    
    func setupImageView(logoImageView: UIImageView) {
        addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: LogoConstants.logoImageWidth).isActive = true
        logoImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: LogoConstants.logoImageHeight).isActive = true
        logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        logoImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    
    private func setupConstraints(logoImageView: UIImageView) {
        addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: LogoConstants.logoImageWidth).isActive = true
        logoImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: LogoConstants.logoImageHeight).isActive = true
        logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        logoImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        setupImageView(logoImageView: speakerZero)
    }
    
    // MARK: - Animation
    
    func zoomAnimation(_ handler: completion? = nil) {
        let duration: TimeInterval = animationDuration
        speakerZero.isHidden = true
        logoImageView.isHidden = false
        alpha = LogoConstants.startAlpha
        UIView.animate(withDuration: duration, animations: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.logoImageView.transform = LogoConstants.zoomOutTranform
            strongSelf.alpha = 0
            }, completion: { finished in
                DispatchQueue.main.async {
                    self.delegate?.animationHasCompleted()
                }
                
//                DispatchQueue.main.async {
//                    weak var appDelegate = UIApplication.shared.delegate as? AppDelegate
//                    let coordinator = AppCoordinator(navigationController: UINavigationController(rootViewController: StartViewController()))
//                    appDelegate?.window?.rootViewController = coordinator.navigationController
//                }
                handler?()
        })
    }
}
