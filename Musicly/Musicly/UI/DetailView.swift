//
//  DetailView.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 4/23/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

class DetailView: UIView {
    
    var playlistNameField: UITextField = {
        var playlistNameField = UITextField()
        playlistNameField.layer.borderColor = UIColor(red:0.13, green:0.21, blue:0.44, alpha:1.0).cgColor
        playlistNameField.layer.cornerRadius = 5
        playlistNameField.layer.borderWidth = 1
        return playlistNameField
    }()
    
    var titleLabel: UILabel = {
        var titleLabel = UILabel()
        titleLabel.backgroundColor = UIColor(red:0.13, green:0.21, blue:0.44, alpha:1.0)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.font =  UIFont(name: "Avenir-Book", size: 18)
        return titleLabel
    }()
    
    var detailsTextView: UITextView = {
        var detailsTextView = UITextView()
        detailsTextView.sizeToFit()
        detailsTextView.textAlignment = .center
        detailsTextView.isScrollEnabled = true
        return detailsTextView
    }()
    
    let doneButton: UIButton = {
        var button = ButtonType.system(title: "Done", color: UIColor.white)
        var uiButton = button.newButton
        uiButton.layer.cornerRadius = 0
        return uiButton
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.borderWidth = 1
        isUserInteractionEnabled = true
        backgroundColor = UIColor.white
        layer.cornerRadius = 2.0
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.clear.cgColor
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width:0,height: 2.0)
        layer.shadowRadius = 1.0
        layer.shadowOpacity = 0.5
        layer.masksToBounds = true
        layer.shadowPath = UIBezierPath(roundedRect:bounds, cornerRadius:layer.cornerRadius).cgPath
    }
    
    // MARK: - Configure View
    
    func configureView(playlist: Playlist) {
        titleLabel.text = "Create Playlist"
        guard let url = URL(string: (playlist.playlistItem(at: 0)?.track?.artworkUrl)!) else { return }
        layoutSubviews()
        setupConstraints()
    }
    
    // MARK: - Configure constraints
    
    func setupConstraints() {
        addSubview(playlistNameField)
        playlistNameField.translatesAutoresizingMaskIntoConstraints = false
        playlistNameField.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        playlistNameField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        playlistNameField.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.15).isActive = true
        playlistNameField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9).isActive = true

        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.15).isActive = true

        addSubview(doneButton)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        doneButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        doneButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.14).isActive = true
        doneButton.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    }
}
