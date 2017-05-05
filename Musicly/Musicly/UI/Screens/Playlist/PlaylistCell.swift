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
        playlistArtView.layer.borderColor = UIColor.black.cgColor
        playlistArtView.layer.borderWidth = 1.5
        return playlistArtView
    }()
    
    private var listTypeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont(name: "Avenir-Medium", size: 14)!
        return label
    }()
    
    private var cellImage: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "cellbutton")
        return image
    }()
    
    private var playlistNameLabel: UILabel = {
        var playlistNameLabel = UILabel()
        playlistNameLabel.textAlignment = .left
        playlistNameLabel.font = UIFont(name: "Avenir-Medium", size: 22)!
        return playlistNameLabel
    }()
    
    private var numberOfSongsLabel: UILabel = {
        let numberOfSongs = UILabel()
        numberOfSongs.text = "10"
        numberOfSongs.textAlignment = .left
        numberOfSongs.font =  UIFont(name: "Avenir-Light", size: 14)!
        return numberOfSongs
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
        DispatchQueue.main.async {
            self.playlistArtView.setRounded()
        }
    }
    
    func configure(playlistName: String, artUrl: URL?, numberOfTracks: String) {
        setupConstraints()
        if let artUrl = artUrl {
            playlistArtView.downloadImage(url: artUrl)
        } else {
            playlistArtView.image = #imageLiteral(resourceName: "blue-record")
        }
        listTypeLabel.text = "Playlist"
        playlistNameLabel.text = "\(playlistName)"
        
        guard let numberOfTracks = Int(numberOfTracks) else { return }
        
        if numberOfTracks < 1 {
            numberOfSongsLabel.text = "No Tracks"
        } else if numberOfTracks < 2 {
            numberOfSongsLabel.text = "\(numberOfTracks) Track"
        } else {
            numberOfSongsLabel.text = "\(numberOfTracks) Tracks"
        }
        layoutSubviews()
    }
    
    func setupConstraints() {
        contentView.addSubview(playlistNameLabel)
        playlistNameLabel.translatesAutoresizingMaskIntoConstraints = false
        playlistNameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: contentView.bounds.width * 0.06).isActive = true
        playlistNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: contentView.bounds.height * -0.16).isActive = true
        
        contentView.addSubview(numberOfSongsLabel)
        numberOfSongsLabel.translatesAutoresizingMaskIntoConstraints = false
        numberOfSongsLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: contentView.bounds.width * 0.06).isActive = true
        numberOfSongsLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: contentView.bounds.height * 0.2).isActive = true
        
        contentView.addSubview(listTypeLabel)
        listTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        listTypeLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: contentView.bounds.width * 0.06).isActive = true
        listTypeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: contentView.bounds.height * 0.06).isActive = true
        
        contentView.addSubview(cellImage)
        cellImage.translatesAutoresizingMaskIntoConstraints = false
        cellImage.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.25).isActive = true
        cellImage.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.1).isActive = true
        cellImage.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: contentView.bounds.width * -0.06).isActive = true
        cellImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        contentView.addSubview(playlistArtView)
        playlistArtView.translatesAutoresizingMaskIntoConstraints = false
        playlistArtView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: contentView.bounds.width * 0.06).isActive = true
        playlistArtView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        playlistArtView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.24).isActive = true
        playlistArtView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.65).isActive = true
    }
}
