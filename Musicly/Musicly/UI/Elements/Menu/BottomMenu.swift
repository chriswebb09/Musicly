//
//  BottomMenu.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 4/30/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

protocol MenuDelegate: class {
    func optionOneTapped()
    func optionTwoTapped()
    func optionThreeTapped()
}

class MenuView: UIView {
    
    weak var delegate: MenuDelegate?
    
    var optionOneView: MenuOptionView = {
        let optionOne = MenuOptionView()
        optionOne.setupConstraints()
        optionOne.isUserInteractionEnabled = true
        optionOne.layer.borderColor = UIColor.white.cgColor
        optionOne.layer.borderWidth = 1
        return optionOne
    }()
    
    var optionTwoView: MenuOptionView = {
        let optionTwo = MenuOptionView()
        optionTwo.setupConstraints()
        optionTwo.isUserInteractionEnabled = true
        optionTwo.layer.borderColor = UIColor.white.cgColor
        optionTwo.layer.borderWidth = 1
        return optionTwo
    }()
    
    var optionThreeView: MenuOptionView = {
        let optionThree = MenuOptionView()
        optionThree.setupConstraints()
        optionThree.isUserInteractionEnabled = true
        optionThree.layer.borderColor = UIColor.white.cgColor
        optionThree.layer.borderWidth = 1
        return optionThree
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = UIColor(red:0.09, green:0.14, blue:0.31, alpha:1.0)
        alpha = 0.98
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
    
    func addSelectors() {
        let optionOneTapped = UITapGestureRecognizer(target: self, action: #selector(optionOneViewTapped))
        optionOneView.addGestureRecognizer(optionOneTapped)
        let optionTwoTapped = UITapGestureRecognizer(target: self, action: #selector(optionTwoViewTapped))
        optionTwoView.addGestureRecognizer(optionTwoTapped)
        let optionThreeTapped = UITapGestureRecognizer(target: self, action: #selector(optionThreeViewTapped))
        optionThreeView.addGestureRecognizer(optionThreeTapped)
    }
    
    func optionOneViewTapped() {
        delegate?.optionOneTapped()
    }
    
    func optionTwoViewTapped() {
        delegate?.optionTwoTapped()
    }
    
    func optionThreeViewTapped() {
        delegate?.optionThreeTapped()
    }
    
    func configureView() {
        layoutSubviews()
        setupConstraints()
        optionOneView.setText(string: "Download")
        optionTwoView.setText(string: "Remove From Playlist")
        optionThreeView.setText(string: "Delete")
        addSelectors()
    }
    
    private func setupConstraints() {
        addSubview(optionOneView)
        optionOneView.translatesAutoresizingMaskIntoConstraints = false
        optionOneView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        optionOneView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        optionOneView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        optionOneView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.33).isActive = true
        
        addSubview(optionTwoView)
        optionTwoView.translatesAutoresizingMaskIntoConstraints = false
        optionTwoView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        optionTwoView.topAnchor.constraint(equalTo: optionOneView.bottomAnchor).isActive = true
        optionTwoView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        optionTwoView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.33).isActive = true
        
        addSubview(optionThreeView)
        optionThreeView.translatesAutoresizingMaskIntoConstraints = false
        optionThreeView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        optionThreeView.topAnchor.constraint(equalTo: optionTwoView.bottomAnchor).isActive = true
        optionThreeView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        optionThreeView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.34).isActive = true
        
    }
}
