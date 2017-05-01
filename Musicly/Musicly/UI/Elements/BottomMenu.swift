//
//  BottomMenu.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 4/30/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

class MenuView: UIView {
    
    
    var optionOneView: UIView = {
        let optionOne = UIView()
        optionOne.layer.borderColor = UIColor.white.cgColor
        optionOne.layer.borderWidth = 1
        return optionOne
    }()
    
    var optionTwoView: UIView = {
        let optionTwo = UIView()
        optionTwo.layer.borderColor = UIColor.white.cgColor
        optionTwo.layer.borderWidth = 1
        return optionTwo
    }()
    
    var optionThreeView: UIView = {
        let optionThree = UIView()
        // optionThree.backgroundColor = .white
        optionThree.layer.borderColor = UIColor.white.cgColor
        optionThree.layer.borderWidth = 1
        return optionThree
    }()
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .black
        isUserInteractionEnabled = true
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 2
        layer.cornerRadius = DetailViewConstants.cornerRadius
        layer.borderWidth = DetailViewConstants.borderWidth
        layer.borderColor = UIColor.clear.cgColor
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowRadius = DetailViewConstants.borderWidth
        layer.shadowOpacity = DetailViewConstants.shadowOpacity
        layer.masksToBounds = true
        layer.shadowPath = UIBezierPath(roundedRect:bounds, cornerRadius:layer.cornerRadius).cgPath
    }
    
    func configureView() {
        layoutSubviews()
        setupConstraints()
    }
    
    private func setupConstraints() {
        addSubview(optionOneView)
        optionOneView.translatesAutoresizingMaskIntoConstraints = false
        optionOneView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        optionOneView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        optionOneView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        optionOneView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.25).isActive = true
        
        addSubview(optionThreeView)
        optionThreeView.translatesAutoresizingMaskIntoConstraints = false
        optionThreeView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        optionThreeView.topAnchor.constraint(equalTo: optionOneView.bottomAnchor).isActive = true
        optionThreeView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        optionThreeView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.25).isActive = true
        
    }
}
