//
//  TrackCell.swift
//  Musically
//
//  Created by Christopher Webb-Orenstein on 4/9/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

final internal class TrackCell: UICollectionViewCell {
    
    private var viewModel: TrackCellViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            trackNameLabel.text = viewModel.trackName
        }
    }
    
    // Song name
    
    private var trackNameLabel: UILabel = {
        var trackName = UILabel()
        trackName.backgroundColor = .white
        trackName.font = TrackCellConstants.smallFont
        trackName.textAlignment = .center
        trackName.numberOfLines = 0
        return trackName
    }()
    
    private var albumArtView: UIImageView = {
        var album = UIImageView()
        return album
    }()
    
    // Cell shadow
    
    private func setShadow() {
        layer.setCellShadow(contentView: contentView)
        let path =  UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius)
        layer.shadowPath = path.cgPath
    }
    
    func configureCell(with model: TrackCellViewModel, withTime: Double) {
        alpha = 0
        viewModel  = model
        albumArtView.downloadImage(url: model.albumImageUrl)
        layoutSubviews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        viewConfigurations()
    }
    
    // MARK: View setup methods
    
    private func viewConfigurations() {
        setShadow()
        setupAlbumArt(albumArtView: albumArtView)
        setupTrackInfoLabel(trackNameLabel: trackNameLabel)
    }
    
    private func setupAlbumArt(albumArtView: UIImageView) {
        contentView.addSubview(albumArtView)
        albumArtView.translatesAutoresizingMaskIntoConstraints = false
        albumArtView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: TrackCellConstants.albumHeightMultiplier).isActive = true
        albumArtView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        albumArtView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
    }
    
    private func setupTrackInfoLabel(trackNameLabel: UILabel) {
        contentView.addSubview(trackNameLabel)
        trackNameLabel.translatesAutoresizingMaskIntoConstraints = false
        trackNameLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: TrackCellConstants.labelHeightMultiplier).isActive = true
        trackNameLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        trackNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
}
