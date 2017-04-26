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
      //  playlistArtView.layer.borderWidth = PlaylistCellConstants.cornerRadius
        playlistArtView.clipsToBounds = true
        return playlistArtView
    }()
    
    private var playlistNameLabel: UILabel = {
        var playlistNameLabel = UILabel()
     
        playlistNameLabel.font =  UIFont(name: "Avenir-Book", size: 18)!
        return playlistNameLabel
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        isUserInteractionEnabled = true
        backgroundColor = .white
        
        contentView.layer.cornerRadius = PlaylistCellConstants.cornerRadius
        contentView.layer.borderWidth = PlaylistCellConstants.borderWidth
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
        
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = PlaylistCellConstants.shadowOffset
        layer.shadowRadius = PlaylistCellConstants.borderWidth
        layer.shadowOpacity = PlaylistCellConstants.shadowOpacity
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
    }
    
    func configure(playlistName: String, artUrl: URL?) {
        setupConstraints()
        if let artUrl = artUrl {
            self.playlistArtView.downloadImage(url: artUrl)
        } else {
            self.playlistArtView.image = #imageLiteral(resourceName: "blue-record")
        }
        self.playlistNameLabel.text = "Playlist: \(playlistName)"
        layoutSubviews()
    }
    
    func setupConstraints() {
        contentView.addSubview(playlistNameLabel)
        playlistNameLabel.translatesAutoresizingMaskIntoConstraints = false
        playlistNameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: PlaylistCellConstants.nameLabelCenterX).isActive = true
        playlistNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        contentView.addSubview(playlistArtView)
        playlistArtView.translatesAutoresizingMaskIntoConstraints = false
        playlistArtView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: contentView.bounds.height * 0.1).isActive = true
        playlistArtView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        playlistArtView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: PlaylistCellConstants.artViewMultiplier).isActive = true
        playlistArtView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: PlaylistCellConstants.artViewWidthMultiplier).isActive = true
    }
}
