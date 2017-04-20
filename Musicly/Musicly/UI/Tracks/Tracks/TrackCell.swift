//
//  TrackCell.swift
//  Musically
//
//  Created by Christopher Webb-Orenstein on 4/9/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

final internal class TrackCell: UICollectionViewCell, Reusable {
    
    var reuseID: String = "trackCell"
    private var trackNameLabel: UILabel? = {
        var trackName = UILabel()
        trackName.backgroundColor = .white
        trackName.font = TrackCellConstants.smallFont
        trackName.textAlignment = .center
        trackName.numberOfLines = 0
        return trackName
    }()
    
    private var albumArtView: UIImageView? = {
        var album = UIImageView()
        return album
    }()
    
    // TODO: - This can be implemented better
    
    private func setShadow() {
        layer.setCellShadow(contentView: contentView)
        let path =  UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius)
        layer.shadowPath = path.cgPath
    }
    
    func configureCell(with trackName: String, with artworkUrl: String) {
        if let url = URL(string: artworkUrl), let trackNameLabel = trackNameLabel, let albumArtView = albumArtView {
            albumArtView.downloadImage(url: url)
            trackNameLabel.text = trackName
        }
        layoutSubviews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        viewConfigurations()
    }
    
    // MARK: View setup methods
    
    private func viewConfigurations() {
        setShadow()
        setupAlbumArt()
        setupTrackInfoLabel()
    }
    
    private func setupAlbumArt() {
        if let albumArtView = albumArtView {
            contentView.addSubview(albumArtView)
            albumArtView.translatesAutoresizingMaskIntoConstraints = false
            albumArtView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
            albumArtView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: TrackCellConstants.albumHeightMultiplier).isActive = true
            albumArtView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        }
    }
    
    private func setupTrackInfoLabel() {
        if let trackNameLabel = trackNameLabel {
            contentView.addSubview(trackNameLabel)
            trackNameLabel.translatesAutoresizingMaskIntoConstraints = false
            trackNameLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: TrackCellConstants.labelHeightMultiplier).isActive = true
            trackNameLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
            trackNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        }
    }
}

struct TrackCellConstants {
    static let smallFont = UIFont(name: "Avenir-Book", size: 10)
    static let albumHeightMultiplier: CGFloat =  0.86
    static let labelHeightMultiplier: CGFloat = 0.2
}
