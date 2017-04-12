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

final class TrackCell: UICollectionViewCell {
    
    var model: TrackViewModel?
    
    var downloadOverlayView: UIView = {
        let downloadOverlay = UIView()
        downloadOverlay.backgroundColor = .black
        downloadOverlay.alpha = 0
        return downloadOverlay
    }()
    
    var downloaded: Bool = false {
        didSet {
            self.playButton.isHidden = false
        }
    }
    
    var downloadButton: UIButton = {
        var downloadButton = UIButton()
        downloadButton.setImage(#imageLiteral(resourceName: "downloadicon"), for: .normal)
        return downloadButton
    }()
    
    var playButton: UIButton = {
        var playButton = UIButton()
        playButton.setImage(#imageLiteral(resourceName: "playbutton"), for: .normal)
        return playButton
    }()
    
    var pauseButton: UIButton = {
        var pauseButton = UIButton()
        pauseButton.setImage(#imageLiteral(resourceName: "pause-icon"), for: .normal)
        return pauseButton
    }()
    
    var progressLabel: UILabel = {
        var progressLabel = UILabel()
        progressLabel.textColor = .white
        progressLabel.font = UIFont(name: "Avenir-Black", size: 16)
        progressLabel.textAlignment = .center
        return progressLabel
    }()
    
    var trackNameLabel: UILabel = {
        var trackName = UILabel()
        trackName.backgroundColor = .white
        trackName.font = UIFont(name: "Avenir-Light", size: 12)
        trackName.textAlignment = .center
        trackName.numberOfLines = 0
        return trackName
    }()
    
    weak var delegate: TrackCellDelegate?
    
    var albumArtView: UIImageView = {
        var album = UIImageView()
        return album
    }()
    
    var track: iTrack?
    var download: Download?
    
    func downloadTapped(tap: Bool, index: Int) {
        downloadButton.alpha = 0
        contentView.bringSubview(toFront: downloadOverlayView)
        downloadOverlayView.alpha = 0.2
        
        if let track = track {
            
            download = Download(url: track.previewUrl)
            download?.delegate = self
            
            if let download = self.download {
                contentView.bringSubview(toFront: progressLabel)
                progressLabel.alpha = 1
                delegate?.downloadButtonTapped(tapped: true, download: download)
                downloadButton.isEnabled = false
            }
        }
    }
    
    func setShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: contentView.bounds.height * 0.00001,
                                    height: contentView.bounds.width * 0.0002)
        layer.shadowRadius = 1.5
        layer.shadowOpacity = 0.5
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
    }
    
    func configureWith(_ track: iTrack?) {
        self.track = track
        layoutSubviews()
        
        if let track = track,
            let url = URL(string: track.artworkUrl) {
            albumArtView.downloadImage(url: url)
        }
        
        self.trackNameLabel.text = track?.trackName
        playButton.isEnabled = false
        pauseButton.isEnabled = false
        playButton.alpha = 0
        pauseButton.alpha = 0
        downloadButton.alpha = 0.6
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        downloadOverlayView.layer.masksToBounds = true
        setupAlbumArt()
        setupViews()
        setupDownloadButton()
        setupPlaybutton()
    }
    
    func setupAlbumArt() {
        contentView.addSubview(albumArtView)
        albumArtView.translatesAutoresizingMaskIntoConstraints = false
        
        albumArtView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        albumArtView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.86).isActive = true
        albumArtView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        
    }
    
    func setupViews() {
        contentView.frame = bounds
        viewConfigurations()
        setShadow()
    }
    
    func setupOverlay() {
        contentView.addSubview(downloadOverlayView)
        downloadOverlayView.translatesAutoresizingMaskIntoConstraints = false
        downloadOverlayView.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
        downloadOverlayView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
    }
    
    func setupDownloadButton() {
        contentView.addSubview(downloadButton)
        downloadButton.translatesAutoresizingMaskIntoConstraints = false
        
        downloadButton.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
        downloadButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: contentView.bounds.width * 0.12).isActive = true
        downloadButton.centerYAnchor.constraint(equalTo: albumArtView.centerYAnchor).isActive = true
    }
    
    func setupPlaybutton() {
        contentView.addSubview(playButton)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        
        playButton.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.86).isActive = true
        playButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: contentView.bounds.width * 0.12).isActive = true
        playButton.centerYAnchor.constraint(equalTo: albumArtView.centerYAnchor).isActive = true
        playButton.centerXAnchor.constraint(equalTo: albumArtView.centerXAnchor).isActive = true
    }
    
    func setupPauseButton() {
        contentView.addSubview(pauseButton)
        pauseButton.translatesAutoresizingMaskIntoConstraints = false
        
        pauseButton.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.9).isActive = true
        pauseButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: contentView.bounds.width * 0.1).isActive = true
        pauseButton.centerYAnchor.constraint(equalTo: albumArtView.centerYAnchor).isActive = true
        pauseButton.centerXAnchor.constraint(equalTo: albumArtView.centerXAnchor).isActive = true
    }

    
    func viewConfigurations() {
        setupView(view: downloadButton)
        setupOverlay()
        downloadButton.addTarget(self, action: #selector(downloadTapped(tap:index:)), for: .touchUpInside)
        setupView(view: progressLabel)
        playButton.addTarget(self, action: #selector(playButtonTapped(tap:index:)), for: .touchUpInside)
        setupPauseButton()
        pauseButton.addTarget(self, action: #selector(pauseButtonTapped(tap:)), for: .touchUpInside)
        setupTrackInfoLabel()
    }
    
    func setupTrackInfoLabel() {
        contentView.addSubview(trackNameLabel)
        
        trackNameLabel.translatesAutoresizingMaskIntoConstraints = false
        trackNameLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.2).isActive = true
        trackNameLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        trackNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
    }
    
    func setupView(view: UIView) {
        contentView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
        view.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        view.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        view.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        albumArtView.image = nil
        track = nil
        download = nil
        progressLabel.text = nil
        delegate = nil
    }
}

extension TrackCell: DownloadDelegate {
    
    func downloadProgressUpdated(for progress: Float, for url: String, task: URLSessionDownloadTask) {
        
        contentView.bringSubview(toFront: downloadOverlayView)
        
        DispatchQueue.main.async { [unowned self] in
            self.progressLabel.text = String(format: "%.1f%%",  progress * 100)
            
            if progress == 1 {
                self.downloadOverlayView.alpha = 0
                self.progressLabel.isHidden = true
                self.pauseButton.isHidden = false
                self.downloadButton.isEnabled = false
                self.playButton.isEnabled = true
                self.playButton.alpha = 0.6
            }
        }
    }
}
