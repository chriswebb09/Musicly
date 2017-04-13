//
//  TrackCell.swift
//  Musically
//
//  Created by Christopher Webb-Orenstein on 4/9/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

protocol TrackCellDelegate: class {
    func downloadButtonTapped(tapped: Bool, download: Download?)
    func playButtonTapped(tapped: Bool, download: Download? )
    func pauseButtonTapped(tapped: Bool)
}

final internal class TrackCell: UICollectionViewCell {
    
    weak var delegate: TrackCellDelegate?
    
    fileprivate var downloadOverlayView: UIView = {
        let downloadOverlay = UIView()
        downloadOverlay.backgroundColor = .black
        downloadOverlay.alpha = 0
        return downloadOverlay
    }()
    
   fileprivate var downloaded: Bool = false {
        didSet {
            playButton.alpha = 0.6
            downloadOverlayView.alpha = 0
            contentView.bringSubview(toFront: playButton)
        }
    }
    
    fileprivate var downloadButton: UIButton = {
        var downloadButton = UIButton()
        downloadButton.setImage(#imageLiteral(resourceName: "download200x"), for: .normal)
        downloadButton.alpha = 0
        return downloadButton
    }()
    
    fileprivate var playButton: UIButton = {
        var playButton = UIButton()
        playButton.setImage(#imageLiteral(resourceName: "pausebutton200x"), for: .normal)
        return playButton
    }()
    
    fileprivate var pauseButton: UIButton = {
        var pauseButton = UIButton()
        pauseButton.setImage(#imageLiteral(resourceName: "playbutton200x"), for: .normal)
        return pauseButton
    }()
    
    fileprivate var progressLabel: UILabel = {
        var progressLabel = UILabel()
        progressLabel.textColor = .white
        progressLabel.font = UIFont(name: "Avenir-Black", size: 16)
        progressLabel.textAlignment = .center
        return progressLabel
    }()
    
    fileprivate var trackNameLabel: UILabel = {
        var trackName = UILabel()
        trackName.backgroundColor = .white
        trackName.font = UIFont(name: "Avenir-Book", size: 12)
        trackName.textAlignment = .center
        trackName.numberOfLines = 0
        return trackName
    }()
    
    fileprivate var albumArtView: UIImageView = {
        var album = UIImageView()
        return album
    }()
    
    var track: iTrack?
    var download: Download?
    
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
            downloaded = track.downloaded
            trackNameLabel.text = track.trackName
        }
        playButton.isEnabled = false
        pauseButton.isEnabled = false
        playButton.alpha = 0
        pauseButton.alpha = 0
        layoutSubviews()
    }
    
    func playButtonTapped(tap: Bool, index: Int) {
        playButton.alpha = 0
        pauseButton.alpha = 0.6
        sendSubview(toBack: downloadOverlayView)
        contentView.sendSubview(toBack: progressLabel)
        if let download = self.download {
            delegate?.playButtonTapped(tapped: true, download: download)
        }
        playButton.isEnabled = false
        pauseButton.isEnabled = true
        bringSubview(toFront: pauseButton)
    }
    
    func pauseButtonTapped(tap: Bool) {
        print("Tap")
        pauseButton.alpha = 0
        playButton.alpha = 0.6
        playButton.isEnabled = true
        delegate?.pauseButtonTapped(tapped: tap)
    }
    
    func downloadTapped(tap: Bool, index: Int) {
        downloadButton.alpha = 0
        contentView.bringSubview(toFront: downloadOverlayView)
        downloadOverlayView.alpha = 0.2
        progressLabel.alpha = 1
        
        if var track = track {
            download = Download(url: track.previewUrl)
            download?.delegate = self
            if let download = self.download {
                contentView.bringSubview(toFront: progressLabel)
                delegate?.downloadButtonTapped(tapped: true, download: download)
                downloadButton.isEnabled = false
                track.downloaded = true
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        viewConfigurations()
        downloadOverlayView.layer.masksToBounds = true
    }
    
    func addButtonTargets() {
        downloadButton.addTarget(self, action: #selector(downloadTapped(tap:index:)), for: .touchUpInside)
        playButton.addTarget(self, action: #selector(playButtonTapped(tap:index:)), for: .touchUpInside)
        pauseButton.addTarget(self, action: #selector(pauseButtonTapped(tap:)), for: .touchUpInside)
    }
    
    func viewConfigurations() {
        setShadow()
        setupAlbumArt()
        addButtonTargets()
        setupPauseButton()
        setupTrackInfoLabel()
        fullSizeConstraints(view: downloadOverlayView)
        fullSizeConstraints(view: progressLabel)
        setupThreeQuartersConstraints(view: downloadButton)
        setupThreeQuartersConstraints(view: playButton)
    }
    
    func setupAlbumArt() {
        contentView.addSubview(albumArtView)
        albumArtView.translatesAutoresizingMaskIntoConstraints = false
        albumArtView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        albumArtView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.86).isActive = true
        albumArtView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
    }
    
    func fullSizeConstraints(view: UIView) {
        contentView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
        view.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        view.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        view.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    func setupThreeQuartersConstraints(view: UIView) {
        contentView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.6).isActive = true
        view.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.7).isActive = true
        view.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        view.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
    }
    
    func setupPauseButton() {
        contentView.addSubview(pauseButton)
        pauseButton.translatesAutoresizingMaskIntoConstraints = false
        pauseButton.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.75).isActive = true
        pauseButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.86).isActive = true
        pauseButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        pauseButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
    }
    
    func setupTrackInfoLabel() {
        contentView.addSubview(trackNameLabel)
        trackNameLabel.translatesAutoresizingMaskIntoConstraints = false
        trackNameLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.2).isActive = true
        trackNameLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        trackNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
    }
}

extension TrackCell: DownloadDelegate {
    
    func downloadProgressUpdated(for progress: Float, for url: String, task: URLSessionDownloadTask) {
        contentView.bringSubview(toFront: downloadOverlayView)
        DispatchQueue.main.async { [unowned self] in
            self.progressLabel.text = String(format: "%.1f%%",  progress * 100)
            
            if progress == 1 {
                self.downloadOverlayView.alpha = 0
                self.downloadButton.isEnabled = false
                self.progressLabel.alpha = 0
                self.playButton.isEnabled = true
                self.playButton.alpha = 0.6
                self.track?.downloaded = true
            }
        }
    }
}
