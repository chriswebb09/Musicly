//
//  PlayerView.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 4/12/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit
import CoreMedia
import AVFoundation

final class PlayerView: UIView {
    
    weak var delegate: PlayerViewDelegate?
    var timer: Timer?
//    var timer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    var track: iTrack?
    
    private var albumArtworkView: UIImageView = {
        var albumArtworkView = UIImageView()
        albumArtworkView.backgroundColor = .white
        return albumArtworkView
    }()
    
    private var progressView: UIProgressView = {
        var progressView = UIProgressView()
      //  progressView.observedProgress = Progress(totalUnitCount: 100)
        progressView.progress = 0.0
        progressView.observedProgress = Progress(totalUnitCount: 0)
        return progressView
    }()
    
    private var artworkView: UIView = {
        var artworkView = UIView()
        artworkView.backgroundColor = UIColor(red:0.86, green:0.87, blue:0.90, alpha:1.0)
        return artworkView
    }()
    
    private var trackTitleView: UIView = {
        let trackTitleView = UIView()
        trackTitleView.backgroundColor = .white
        return trackTitleView
    }()
    
    private var totalPlayLengthLabel: UILabel = {
        let label = UILabel()
        if let font = UIFont(name: "Avenir-Book", size: 18) {
            label.font = font
        }
        label.textColor = .white
        label.textAlignment = .right
        return label
    }()
    
    private var currentPlayLength: UILabel = {
        let label = UILabel()
        label.text = "0:00"
        label.textAlignment = .left
        if let font = UIFont(name: "Avenir-Book", size: 18) {
            label.font = font
        }
        label.textColor = .orange
        return label
    }()
    
    private var thumbsUpButton: UIButton = {
        let thumbsUpButton = UIButton()
        thumbsUpButton.setImage(#imageLiteral(resourceName: "thumbsupiconorange"), for: .normal)
        return thumbsUpButton
    }()
    
    private var thumbsDownButton: UIButton = {
        let thumbsDownButton = UIButton()
        thumbsDownButton.setImage(#imageLiteral(resourceName: "thumbsdownblue"), for: .normal)
        return thumbsDownButton
    }()
    
    private var artistInfoButton: UIButton = {
        var infoButton = UIButton()
        infoButton.setTitle("Artist Bio", for: .normal)
        infoButton.setTitleColor(UIColor(red:0.13, green:0.21, blue:0.44, alpha:1.0), for: .normal)
        return infoButton
    }()
    
    private var controlsView: UIView = {
        let controlsView = UIView()
        controlsView.backgroundColor = UIColor(red:0.13, green:0.21, blue:0.44, alpha:1.0)
        return controlsView
    }()
    
    private var preferencesView: UIView = {
        let preferencesView = UIView()
        preferencesView.backgroundColor = .white
        return preferencesView
    }()
    
    private  var trackTitleLabel: UILabel = {
        var trackTitleLabel = UILabel()
        trackTitleLabel.textColor = UIColor(red:0.13, green:0.21, blue:0.44, alpha:1.0)
        trackTitleLabel.textAlignment = .center
        return trackTitleLabel
    }()
    
    private var playButton: UIButton = {
        var playButton = UIButton()
        playButton.setImage(#imageLiteral(resourceName: "whitetriangleplay"), for: .normal)
        if let imageView = playButton.imageView {
            imageView.layer.setViewShadow(view: imageView)
            imageView.layer.shadowPath = UIBezierPath(roundedRect: imageView.bounds, cornerRadius: imageView.layer.cornerRadius).cgPath
        }
        return playButton
    }()
    
    private var pauseButton: UIButton = {
        var pauseButton = UIButton()
        pauseButton.setImage(#imageLiteral(resourceName: "pausebutton-2white"), for: .normal)
        return pauseButton
    }()
    
    override func layoutSubviews() {
        backgroundColor = UIColor(red:0.86, green:0.87, blue:0.90, alpha:1.0)
        setupView()
        pauseButton.alpha = 0
    }
    
    var time: Int?
    
    func configure(with track: iTrack) {
        self.track = track
        if let url = URL(string: track.artworkUrl) {
            albumArtworkView.downloadImage(url: url)
            trackTitleLabel.text = track.trackName
        }
        albumArtworkView.layer.setCellShadow(contentView: albumArtworkView)
        trackTitleView.layer.setCellShadow(contentView: trackTitleView)
        playButton.layer.setViewShadow(view: playButton)
        addSelectors()
    }
    
    private func addSelectors() {
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        pauseButton.addTarget(self, action: #selector(pauseButtonTapped), for: .touchUpInside)
        thumbsUpButton.addTarget(self, action: #selector(thumbsUpTapped), for: .touchUpInside)
        thumbsDownButton.addTarget(self, action: #selector(thumbsDownTapped), for: .touchUpInside)
    }
    
    private func setupTrackTitleView() {
        addSubview(trackTitleView)
        trackTitleView.translatesAutoresizingMaskIntoConstraints = false
        trackTitleView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        trackTitleView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.08).isActive = true
        trackTitleView.topAnchor.constraint(equalTo: topAnchor).isActive = true
    }
    
    private func setupArtworkView() {
        addSubview(artworkView)
        artworkView.translatesAutoresizingMaskIntoConstraints = false
        artworkView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        artworkView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.4).isActive = true
        artworkView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        artworkView.topAnchor.constraint(equalTo: trackTitleView.bottomAnchor).isActive = true
    }
    
    private func setupAlbumArtworkView() {
        artworkView.addSubview(albumArtworkView)
        albumArtworkView.translatesAutoresizingMaskIntoConstraints = false
        albumArtworkView.widthAnchor.constraint(equalTo: artworkView.widthAnchor, multiplier: 0.5).isActive = true
        albumArtworkView.heightAnchor.constraint(equalTo: artworkView.heightAnchor, multiplier: 0.7).isActive = true
        albumArtworkView.centerXAnchor.constraint(equalTo: artworkView.centerXAnchor).isActive = true
        albumArtworkView.centerYAnchor.constraint(equalTo: artworkView.centerYAnchor).isActive = true
    }
    
    private func setupPreferencesView() {
        addSubview(preferencesView)
        preferencesView.translatesAutoresizingMaskIntoConstraints = false
        preferencesView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        preferencesView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.06).isActive = true
        preferencesView.topAnchor.constraint(equalTo: artworkView.bottomAnchor).isActive = true
    }
    
    private func setupArtistBioButton() {
        preferencesView.addSubview(artistInfoButton)
        artistInfoButton.translatesAutoresizingMaskIntoConstraints = false
        artistInfoButton.widthAnchor.constraint(equalTo: preferencesView.widthAnchor, multiplier: 0.2).isActive = true
        artistInfoButton.heightAnchor.constraint(equalTo: preferencesView.heightAnchor, multiplier: 0.7).isActive = true
        artistInfoButton.rightAnchor.constraint(equalTo: preferencesView.rightAnchor, constant: UIScreen.main.bounds.width * -0.05).isActive = true
        artistInfoButton.centerYAnchor.constraint(equalTo: preferencesView.centerYAnchor).isActive = true
    }
    
    private func setupThumbsUpButton() {
        thumbsButtonSetup(thumbs: thumbsUpButton)
        thumbsUpButton.leftAnchor.constraint(equalTo: preferencesView.leftAnchor, constant: UIScreen.main.bounds.width * 0.06).isActive = true
        thumbsUpButton.centerYAnchor.constraint(equalTo: preferencesView.centerYAnchor).isActive = true
    }
    
    private func setupThumbsDownButton() {
        thumbsButtonSetup(thumbs: thumbsDownButton)
        thumbsDownButton.leftAnchor.constraint(equalTo: preferencesView.leftAnchor, constant: UIScreen.main.bounds.width * 0.21).isActive = true
        thumbsDownButton.centerYAnchor.constraint(equalTo: preferencesView.centerYAnchor).isActive = true
    }
    
    private func thumbsButtonSetup(thumbs: UIButton) {
        preferencesView.addSubview(thumbs)
        thumbs.translatesAutoresizingMaskIntoConstraints = false
        thumbs.widthAnchor.constraint(equalTo: preferencesView.widthAnchor, multiplier: 0.07).isActive = true
        thumbs.heightAnchor.constraint(equalTo: preferencesView.heightAnchor, multiplier: 0.7).isActive = true
    }
    
    private func setupControlsView() {
        addSubview(controlsView)
        controlsView.translatesAutoresizingMaskIntoConstraints = false
        controlsView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        controlsView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.55).isActive = true
        controlsView.topAnchor.constraint(equalTo: preferencesView.bottomAnchor).isActive = true
    }
    
    private func setupTrackTitleLabel() {
        trackTitleView.addSubview(trackTitleLabel)
        trackTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        trackTitleLabel.widthAnchor.constraint(equalTo: trackTitleView.widthAnchor, multiplier: 1).isActive = true
        trackTitleLabel.heightAnchor.constraint(equalTo: trackTitleView.heightAnchor, multiplier: 0.6).isActive = true
        trackTitleLabel.centerYAnchor.constraint(equalTo: trackTitleView.centerYAnchor, constant: controlsView.bounds.height * 0.5).isActive = true
    }
    
    private func setupTrackButtons(button: UIButton) {
        controlsView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalTo: controlsView.widthAnchor, multiplier: 0.16).isActive = true
        button.heightAnchor.constraint(equalTo: controlsView.heightAnchor, multiplier: 0.16).isActive = true
        button.centerXAnchor.constraint(equalTo: controlsView.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: controlsView.centerYAnchor, constant: UIScreen.main.bounds.height * -0.06).isActive = true
    }
    
    private func setupPlayButton() {
        setupTrackButtons(button: playButton)
    }
    
    private func setupPauseButton() {
        setupTrackButtons(button: pauseButton)
    }
    
    private func setupProgressView() {
        controlsView.addSubview(progressView)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.widthAnchor.constraint(equalTo: controlsView.widthAnchor, multiplier: 0.6).isActive = true
        progressView.heightAnchor.constraint(equalTo: controlsView.heightAnchor, multiplier: 0.01).isActive = true
        progressView.centerXAnchor.constraint(equalTo: controlsView.centerXAnchor).isActive = true
        progressView.centerYAnchor.constraint(equalTo: controlsView.centerYAnchor, constant: UIScreen.main.bounds.height * -0.17).isActive = true
    }
    
    private func setupTotalPlayLengthLabel() {
        controlsView.addSubview(totalPlayLengthLabel)
        totalPlayLengthLabel.translatesAutoresizingMaskIntoConstraints = false
        totalPlayLengthLabel.widthAnchor.constraint(equalTo: controlsView.widthAnchor, multiplier: 0.18).isActive = true
        totalPlayLengthLabel.heightAnchor.constraint(equalTo: controlsView.heightAnchor, multiplier: 0.25).isActive = true
        totalPlayLengthLabel.rightAnchor.constraint(equalTo: controlsView.rightAnchor, constant: UIScreen.main.bounds.width * -0.07).isActive = true
        totalPlayLengthLabel.centerYAnchor.constraint(equalTo: controlsView.centerYAnchor, constant: UIScreen.main.bounds.height * -0.17).isActive = true
    }
    
    private func setupCurrentPlayLength() {
        controlsView.addSubview(currentPlayLength)
        currentPlayLength.translatesAutoresizingMaskIntoConstraints = false
        currentPlayLength.widthAnchor.constraint(equalTo: controlsView.widthAnchor, multiplier: 0.15).isActive = true
        currentPlayLength.heightAnchor.constraint(equalTo: controlsView.heightAnchor, multiplier: 0.25).isActive = true
        currentPlayLength.leftAnchor.constraint(equalTo: controlsView.leftAnchor, constant: UIScreen.main.bounds.width * 0.07).isActive = true
        currentPlayLength.centerYAnchor.constraint(equalTo: controlsView.centerYAnchor, constant: UIScreen.main.bounds.height * -0.17).isActive = true
    }
    
    fileprivate func setupView() {
        setupTrackTitleView()
        setupArtworkView()
        setupAlbumArtworkView()
        setupPreferencesView()
        setupArtistBioButton()
        setupThumbsUpButton()
        setupThumbsDownButton()
        setupControlsView()
        setupTrackTitleLabel()
        setupPlayButton()
        setupProgressView()
        setupPauseButton()
        setupTotalPlayLengthLabel()
        setupCurrentPlayLength()
    }
    
    func downloadButtonTapped() {
        delegate?.downloadButtonTapped()
    }
    
    func switchThumbs() {
        if let track = track {
            if track.thumbs == .down {
                thumbsDownButton.setImage(#imageLiteral(resourceName: "thumbsdownorange"), for: .normal)
                thumbsUpButton.setImage(#imageLiteral(resourceName: "thumbsupblue"), for: .normal)
            } else if track.thumbs == .up {
                thumbsUpButton.setImage(#imageLiteral(resourceName: "thumbsupiconorange"), for: .normal)
                thumbsDownButton.setImage(#imageLiteral(resourceName: "thumbsdownblue"), for: .normal)
            } else if track.thumbs == .none {
                thumbsUpButton.setImage(#imageLiteral(resourceName: "thumbsupblue"), for: .normal)
                thumbsDownButton.setImage(#imageLiteral(resourceName: "thumbsdownblue"), for: .normal)
            }
        }
    }
    var timerDic:NSMutableDictionary = ["count": 0]
    
    func setupTimeLabels(totalTime: String) {
        totalPlayLengthLabel.text = totalTime
    }
    
    func updateTime() {
        if let timerDic = timer?.userInfo as? NSMutableDictionary {
            if let count = timerDic["count"] as? Int {
                timerDic["count"] = count + 1
                progressView.progress += 0.0342
                dump(progressView.observedProgress)
                time = count
                constructTimeString()
            }
        }
    }

    func pauseTime() {
        if let timerDic = timer?.userInfo as? NSMutableDictionary {
            if let count = timerDic["count"] as? Int {
                timerDic["count"] = count
                
                currentPlayLength.text = String(describing: count)
            }
        }
    }

    @objc private func thumbsUpTapped() {
        if self.track?.thumbs == .up {
            self.track?.thumbs = .none
        } else {
            self.track?.thumbs = .up
        }
        switchThumbs()
        delegate?.thumbsUpTapped()
    }
    
    @objc private func thumbsDownTapped() {
        if self.track?.thumbs == .down {
            self.track?.thumbs = .none
        } else {
            self.track?.thumbs = .down
        }
        switchThumbs()
        delegate?.thumbsDownTapped()
    }
    
    func constructTimeString() {
        var timeString = String(describing: time!)
        var timerString = ""
        print(timeString)
        if timeString.characters.count < 2 {
            timerString = "0:0\(timeString)"
        } else if timeString.characters.count <= 2 {
            timerString = "0:\(timeString)"
        }
        currentPlayLength.text = timerString
    }
    
    
    @objc private func playButtonTapped() {
        timer?.invalidate() 
        if let timerDic = timer?.userInfo as? NSMutableDictionary {
            if let count = timerDic["count"] as? Int {
                timerDic["count"] = count + 1
                currentPlayLength.text = String(describing: count)
            }
        }
        // start the timer
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateTime), userInfo: timerDic, repeats: true)
        delegate?.playButtonTapped()
        playButton.isEnabled = false
        playButton.alpha = 0
        pauseButton.isEnabled = true
        pauseButton.alpha = 1
        controlsView.bringSubview(toFront: pauseButton)
        controlsView.sendSubview(toBack: playButton)
    }
    
    @objc private func pauseButtonTapped() {
        timer?.invalidate()
      //  pauseTime()
        delegate?.pauseButtonTapped()
        controlsView.bringSubview(toFront: playButton)
        controlsView.sendSubview(toBack: pauseButton)
        playButton.isEnabled = true
        playButton.alpha = 1
        pauseButton.isEnabled = false
        pauseButton.alpha = 0
    }
}
