//
//  TrackCell.swift
//  Musically
//
//  Created by Christopher Webb-Orenstein on 4/9/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

final internal class TrackCell: UICollectionViewCell {

    fileprivate var trackNameLabel: UILabel = {
        var trackName = UILabel()
        trackName.backgroundColor = .white
        trackName.font = UIFont(name: "Avenir-Book", size: 10)
        trackName.textAlignment = .center
        trackName.numberOfLines = 0
        return trackName
    }()
    
    fileprivate var albumArtView: UIImageView = {
        var album = UIImageView()
        return album
    }()
    
    var track: iTrack?
    
    func setShadow() {
        layer.setCellShadow(contentView: contentView)
        layer.shadowPath = UIBezierPath(roundedRect: bounds,
                                        cornerRadius: contentView.layer.cornerRadius).cgPath
    }
    
    func configureWith(_ track: iTrack?) {
        self.track = track
        if let track = track,
            let url = URL(string: track.artworkUrl) {
            albumArtView.downloadImage(url: url)
            trackNameLabel.text = track.trackName
        }
        layoutSubviews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        viewConfigurations()
    }
    
    func viewConfigurations() {
        setShadow()
        setupAlbumArt()
        setupTrackInfoLabel()
    }
    
    func setupAlbumArt() {
        contentView.addSubview(albumArtView)
        albumArtView.translatesAutoresizingMaskIntoConstraints = false
        albumArtView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        albumArtView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.86).isActive = true
        albumArtView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
    }
    
    func setupTrackInfoLabel() {
        contentView.addSubview(trackNameLabel)
        trackNameLabel.translatesAutoresizingMaskIntoConstraints = false
        trackNameLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.2).isActive = true
        trackNameLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        trackNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
    }
}
