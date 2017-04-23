//
//  PlaylistCell.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 4/22/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

final class PlaylistCell: UICollectionViewCell {
    
    private var playlistArtView: UIImageView = {
        var playlistArtView = UIImageView()
        playlistArtView.layer.borderWidth = 2
        playlistArtView.clipsToBounds = true
        return playlistArtView
    }()
    
    private var playlistNameLabel: UILabel = {
        var playlistNameLabel = UILabel()
        playlistNameLabel.sizeToFit()
        playlistNameLabel.font = UIFont(name: "HelveticaNeue", size: 22)
        return playlistNameLabel
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        isUserInteractionEnabled = true
        backgroundColor = .white
        
        contentView.layer.cornerRadius = 2.0
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
        
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width:0, height: 2.0)
        layer.shadowRadius = 1.0
        layer.shadowOpacity = 0.5
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
    }
    
    func configure(playlistName: String, artUrl: URL) {
        setupConstraints()
        self.playlistNameLabel.text = playlistName
        self.playlistArtView.downloadImage(url: artUrl)
        layoutSubviews()
    }
    
    
    func setupConstraints() {
        contentView.addSubview(playlistNameLabel)
        playlistNameLabel.translatesAutoresizingMaskIntoConstraints = false
        playlistNameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: contentView.bounds.width * 0.2).isActive = true
       playlistNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: contentView.bounds.height * -0.12).isActive = true
        
        contentView.addSubview(playlistArtView)
        playlistArtView.translatesAutoresizingMaskIntoConstraints = false
        playlistArtView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: contentView.bounds.height * 0.1).isActive = true
        playlistArtView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        playlistArtView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.25).isActive = true
        playlistArtView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.6).isActive = true
    
    }
    
}
