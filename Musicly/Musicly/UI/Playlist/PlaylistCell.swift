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
        playlistArtView.layer.borderWidth = Constants.cornerRadius
        playlistArtView.clipsToBounds = true
        return playlistArtView
    }()
    
    private var playlistNameLabel: UILabel = {
        var playlistNameLabel = UILabel()
        playlistNameLabel.sizeToFit()
        playlistNameLabel.font = Constants.mainFont
        return playlistNameLabel
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        isUserInteractionEnabled = true
        backgroundColor = .white
        
        contentView.layer.cornerRadius = Constants.cornerRadius
        contentView.layer.borderWidth = Constants.borderWidth
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
        
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = Constants.shadowOffset
        layer.shadowRadius = Constants.borderWidth
        layer.shadowOpacity = Constants.shadowOpacity
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
        playlistNameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: Constants.nameLabelCenterX).isActive = true
        playlistNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: contentView.bounds.height * -0.12).isActive = true
        
        contentView.addSubview(playlistArtView)
        playlistArtView.translatesAutoresizingMaskIntoConstraints = false
        playlistArtView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: contentView.bounds.height * 0.1).isActive = true
        playlistArtView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        playlistArtView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: Constants.artViewMultiplier).isActive = true
        playlistArtView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: Constants.artViewWidthMultiplier).isActive = true
    }
    
    struct Constants {
        static let nameLabelCenterX = UIScreen.main.bounds.width * 0.2
        static let artViewMultiplier: CGFloat = 0.25
        static let artViewWidthMultiplier: CGFloat = 0.6
        static let shadowOffset = CGSize(width: 0, height: 2)
        static let cornerRadius: CGFloat = 2
        static let borderWidth: CGFloat = 1
        static let shadowOpacity: Float = 0.5
        static let mainFont = UIFont(name: "HelveticaNeue", size: 22)!
    }
    
}
