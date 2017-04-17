//
//  PlayerView.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 4/12/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

enum FileState {
    case playing, done, paused
}

final class PlayerView: UIView {
    
    weak var delegate: PlayerViewDelegate?
    private var timer: Timer?
    private var track: iTrack?
    private var playState: FileState?
    private var time: Int?
    private var timerDic: NSMutableDictionary? = ["count": 0]
    
    // MARK: - Cover art
    
    private var albumArtworkView: UIImageView? = {
        var albumArtworkView = UIImageView()
        albumArtworkView.backgroundColor = .clear
        return albumArtworkView
    }()
    
    private var artworkView: UIView? = {
        var artworkView = UIView()
        artworkView.backgroundColor = .appBlue
        return artworkView
    }()
    
    // MARK: - Music controls
    
    private var controlsView: UIView? = {
        let controlsView = UIView()
        controlsView.backgroundColor = .textColor
        return controlsView
    }()
    
    private var playButton: UIButton? = {
        var playButton = UIButton()
        playButton.setImage(#imageLiteral(resourceName: "whitetriangleplay"), for: .normal)
        if let imageView = playButton.imageView {
            imageView.layer.setViewShadow(view: imageView)
            imageView.layer.shadowPath = UIBezierPath(roundedRect: imageView.bounds, cornerRadius: imageView.layer.cornerRadius).cgPath
        }
        return playButton
    }()
    
    private var pauseButton: UIButton? = {
        var pauseButton = UIButton()
        pauseButton.setImage(#imageLiteral(resourceName: "pausebutton-2white"), for: .normal)
        return pauseButton
    }()
    
    private var progressView: UIProgressView? = {
        var progressView = UIProgressView()
        progressView.progress = 0.0
        progressView.progressTintColor = .orange
        progressView.observedProgress = Progress(totalUnitCount: 0)
        return progressView
    }()
    
    private var totalPlayLengthLabel: UILabel? = {
        let label = UILabel()
        if let font = ApplicationConstants.mainFont {
            label.font = font
        }
        label.textColor = .white
        label.textAlignment = .right
        return label
    }()
    
    // Time since player started playing
    
    private var currentPlayLengthLabel: UILabel? = {
        let label = UILabel()
        label.text = "0:00"
        label.textAlignment = .left
        if let font = ApplicationConstants.mainFont {
            label.font = font
        }
        label.textColor = .orange
        return label
    }()
    
    // MARK: - Track title
    
    private var trackTitleView: UIView? = {
        let trackTitleView = UIView()
        trackTitleView.backgroundColor = .white
        return trackTitleView
    }()
    
    private  var trackTitleLabel: UILabel? = {
        var trackTitleLabel = UILabel()
        trackTitleLabel.textColor = .textColor
        trackTitleLabel.textAlignment = .center
        return trackTitleLabel
    }()
    
    // MARK: - Preferences
    
    private var preferencesView: UIView? = {
        let preferencesView = UIView()
        preferencesView.backgroundColor = .white
        return preferencesView
    }()
    
    
    weak var equal: AudioEqualizer? = {
        var size: CGSize? = CGSize(width: 20, height: 20)
        return AudioEqualizer(size: size)
    }()
    
    private var equalView: IndicatorView?
    
    private var thumbsUpButton: UIButton? = {
        let thumbsUpButton = UIButton()
        thumbsUpButton.setImage(#imageLiteral(resourceName: "thumbsupiconorange"), for: .normal)
        return thumbsUpButton
    }()
    
    private var thumbsDownButton: UIButton? = {
        let thumbsDownButton = UIButton()
        thumbsDownButton.setImage(#imageLiteral(resourceName: "thumbsdownblue"), for: .normal)
        return thumbsDownButton
    }()
    
    private var artistInfoButton: UIButton? = {
        var infoButton = UIButton()
        infoButton.setTitle("Artist Bio", for: .normal)
        infoButton.setTitleColor(.textColor, for: .normal)
        return infoButton
    }()
    
    // MARK: - View logic
    
    override func layoutSubviews() {
        backgroundColor = .appBlue
        setupViews()
        pauseButton?.alpha = 0
    }
    
    func configure(with artworkUrl: String?, trackName: String?) {
        if let artworkUrl = artworkUrl,
            let url = URL(string: artworkUrl),
            let trackName = trackName,
            let trackTitleLabel = trackTitleLabel,
            let albumArtworkView = albumArtworkView,
            let trackTitleView =  trackTitleView,
            let playButton = playButton {
            
            albumArtworkView.downloadImage(url: url)
            trackTitleLabel.text = trackName
            albumArtworkView.layer.setCellShadow(contentView: albumArtworkView)
            trackTitleView.layer.setCellShadow(contentView: trackTitleView)
            playButton.layer.setViewShadow(view: playButton)
            addSelectors()
        }
    }
    
    private func addSelectors() {
        guard let playButton = playButton else { return }
        guard let thumbsUpButton = thumbsUpButton else { return }
        guard let thumbsDownButton = thumbsDownButton else { return }
        guard let pauseButton = pauseButton else { return }
        
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        pauseButton.addTarget(self, action: #selector(pauseButtonTapped), for: .touchUpInside)
        thumbsUpButton.addTarget(self, action: #selector(thumbsUpTapped), for: .touchUpInside)
        thumbsDownButton.addTarget(self, action: #selector(thumbsDownTapped), for: .touchUpInside)
    }
    
    private func setupTrackTitleView() {
        guard let trackTitleView = trackTitleView else { return }
        
        addSubview(trackTitleView)
        trackTitleView.translatesAutoresizingMaskIntoConstraints = false
        trackTitleView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        trackTitleView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.08).isActive = true
        trackTitleView.topAnchor.constraint(equalTo: topAnchor).isActive = true
    }
    
    private func setupTrackTitleLabel() {
        guard let trackTitleLabel = trackTitleLabel else { return }
        guard let trackTitleView = trackTitleView else { return }
        guard let controlsView = controlsView  else { return }
        
        trackTitleView.addSubview(trackTitleLabel)
        trackTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        trackTitleLabel.widthAnchor.constraint(equalTo: trackTitleView.widthAnchor).isActive = true
        trackTitleLabel.heightAnchor.constraint(equalTo: trackTitleView.heightAnchor, multiplier: 0.6).isActive = true
        trackTitleLabel.centerYAnchor.constraint(equalTo: trackTitleView.centerYAnchor, constant: controlsView.bounds.height * 0.5).isActive = true
    }
    
    // MARK: - Cover art setup
    
    private func setupArtworkView() {
        guard let artworkView = artworkView else { return }
        guard let trackTitleView = trackTitleView else { return }
        
        addSubview(artworkView)
        artworkView.translatesAutoresizingMaskIntoConstraints = false
        artworkView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        artworkView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.4).isActive = true
        artworkView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        artworkView.topAnchor.constraint(equalTo: trackTitleView.bottomAnchor).isActive = true
    }
    
    private func setupAlbumArtworkView() {
        guard let artworkView = artworkView  else { return }
        guard let albumArtworkView = albumArtworkView  else { return }
        
        artworkView.addSubview(albumArtworkView)
        albumArtworkView.translatesAutoresizingMaskIntoConstraints = false
        albumArtworkView.widthAnchor.constraint(equalTo: artworkView.widthAnchor, multiplier: 0.5).isActive = true
        albumArtworkView.heightAnchor.constraint(equalTo: artworkView.heightAnchor, multiplier: 0.6).isActive = true
        albumArtworkView.centerXAnchor.constraint(equalTo: artworkView.centerXAnchor).isActive = true
        albumArtworkView.centerYAnchor.constraint(equalTo: artworkView.centerYAnchor).isActive = true
        
    }
    
    private func setupPreferencesView() {
        guard let preferencesView = preferencesView else { return }
        guard let artworkView = artworkView  else { return }
        
        addSubview(preferencesView)
        preferencesView.translatesAutoresizingMaskIntoConstraints = false
        preferencesView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        preferencesView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.06).isActive = true
        preferencesView.topAnchor.constraint(equalTo: artworkView.bottomAnchor).isActive = true
        
    }
    
    // MARK: - Preferences setup
    
    private func setupArtistBioButton() {
        guard let artistInfoButton = artistInfoButton else { return }
        guard let preferencesView = preferencesView else { return }
        
        preferencesView.addSubview(artistInfoButton)
        artistInfoButton.translatesAutoresizingMaskIntoConstraints = false
        artistInfoButton.widthAnchor.constraint(equalTo: preferencesView.widthAnchor, multiplier: 0.2).isActive = true
        artistInfoButton.heightAnchor.constraint(equalTo: preferencesView.heightAnchor, multiplier: 0.7).isActive = true
        artistInfoButton.rightAnchor.constraint(equalTo: preferencesView.rightAnchor, constant: UIScreen.main.bounds.width * -0.05).isActive = true
        artistInfoButton.centerYAnchor.constraint(equalTo: preferencesView.centerYAnchor).isActive = true
        
    }
    
    private func setupThumbsUpButton() {
        guard let thumbsUpButton = thumbsUpButton else { return }
        guard let preferencesView = preferencesView else { return }
        
        thumbsButtonSetup(thumbs: thumbsUpButton)
        thumbsUpButton.leftAnchor.constraint(equalTo: preferencesView.leftAnchor, constant: UIScreen.main.bounds.width * 0.06).isActive = true
        thumbsUpButton.centerYAnchor.constraint(equalTo: preferencesView.centerYAnchor).isActive = true
    }
    
    
    private func setupThumbsDownButton() {
        guard let thumbsDownButton = thumbsDownButton else { return }
        guard let preferencesView = preferencesView else { return }
        
        thumbsButtonSetup(thumbs: thumbsDownButton)
        thumbsDownButton.leftAnchor.constraint(equalTo: preferencesView.leftAnchor, constant: UIScreen.main.bounds.width * 0.21).isActive = true
        thumbsDownButton.centerYAnchor.constraint(equalTo: preferencesView.centerYAnchor).isActive = true
    }
    
    private func thumbsButtonSetup(thumbs: UIButton?) {
        guard let preferencesView = preferencesView else { return }
        guard let thumbs = thumbs else { return }
        
        preferencesView.addSubview(thumbs)
        thumbs.translatesAutoresizingMaskIntoConstraints = false
        thumbs.widthAnchor.constraint(equalTo: preferencesView.widthAnchor, multiplier: 0.07).isActive = true
        thumbs.heightAnchor.constraint(equalTo: preferencesView.heightAnchor, multiplier: 0.7).isActive = true
    }
    
    // MARK: - Music controls setup
    
    private func setupControlsView() {
        guard let controlsView = controlsView else { return }
        guard let preferencesView = preferencesView else { return }
        
        addSubview(controlsView)
        controlsView.translatesAutoresizingMaskIntoConstraints = false
        controlsView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        controlsView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.55).isActive = true
        controlsView.topAnchor.constraint(equalTo: preferencesView.bottomAnchor).isActive = true
    }
    
    private func setupTrackButtons(button: UIButton?) {
        guard let controlsView = controlsView else { return }
        guard let button = button else { return }
        
        controlsView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalTo: controlsView.widthAnchor, multiplier: 0.16).isActive = true
        button.heightAnchor.constraint(equalTo: controlsView.heightAnchor, multiplier: 0.16).isActive = true
        button.centerXAnchor.constraint(equalTo: controlsView.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: controlsView.centerYAnchor, constant: UIScreen.main.bounds.height * -0.06).isActive = true
    }
    
    private func setupPlayButton() {
        guard let playButton = playButton else { return }
        
        setupTrackButtons(button: playButton)
    }
    
    private func setupPauseButton() {
        guard let pauseButton = pauseButton else { return }
        
        setupTrackButtons(button: pauseButton)
    }
    
    private func setupProgressView() {
        guard let progressView = progressView else { return }
        guard let controlsView = controlsView else { return }
        
        controlsView.addSubview(progressView)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.widthAnchor.constraint(equalTo: controlsView.widthAnchor, multiplier: 0.6).isActive = true
        progressView.heightAnchor.constraint(equalTo: controlsView.heightAnchor, multiplier: 0.01).isActive = true
        progressView.centerXAnchor.constraint(equalTo: controlsView.centerXAnchor).isActive = true
        progressView.centerYAnchor.constraint(equalTo: controlsView.centerYAnchor, constant: UIScreen.main.bounds.height * -0.17).isActive = true
        
    }
    
    private func setupTotalPlayLengthLabel() {
        guard let controlsView = controlsView else { return }
        guard let totalPlayLengthLabel = totalPlayLengthLabel  else { return }
        
        controlsView.addSubview(totalPlayLengthLabel)
        totalPlayLengthLabel.translatesAutoresizingMaskIntoConstraints = false
        totalPlayLengthLabel.widthAnchor.constraint(equalTo: controlsView.widthAnchor, multiplier: 0.18).isActive = true
        totalPlayLengthLabel.heightAnchor.constraint(equalTo: controlsView.heightAnchor, multiplier: 0.25).isActive = true
        totalPlayLengthLabel.rightAnchor.constraint(equalTo: controlsView.rightAnchor, constant: UIScreen.main.bounds.width * -0.07).isActive = true
        totalPlayLengthLabel.centerYAnchor.constraint(equalTo: controlsView.centerYAnchor, constant: UIScreen.main.bounds.height * -0.17).isActive = true
    }
    
    private func setupCurrentPlayLength() {
        guard let controlsView = controlsView else { return }
        guard let currentPlayLengthLabel = currentPlayLengthLabel else { return }
        
        controlsView.addSubview(currentPlayLengthLabel)
        currentPlayLengthLabel.translatesAutoresizingMaskIntoConstraints = false
        currentPlayLengthLabel.widthAnchor.constraint(equalTo: controlsView.widthAnchor, multiplier: 0.15).isActive = true
        currentPlayLengthLabel.heightAnchor.constraint(equalTo: controlsView.heightAnchor, multiplier: 0.25).isActive = true
        currentPlayLengthLabel.leftAnchor.constraint(equalTo: controlsView.leftAnchor, constant: UIScreen.main.bounds.width * 0.07).isActive = true
        currentPlayLengthLabel.centerYAnchor.constraint(equalTo: controlsView.centerYAnchor, constant: UIScreen.main.bounds.height * -0.17).isActive = true
        
    }
    
    // Configures all subview
    
    fileprivate func setupViews() {
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
    
    // Changes thumb button images depending on selection
    
    private func switchThumbs() {
        if let thumbsDownButton = thumbsDownButton, let thumbsUpButton = thumbsUpButton, let track = track {
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
    
    func setupTimeLabels(totalTime: String?) {
        if let totalTime = totalTime, let totalPlayLengthLabel = totalPlayLengthLabel {
            totalPlayLengthLabel.text = totalTime
        }
    }
    
    // TODO: - This can be implemented better
    
    @objc private func updateTime() {
        guard let timerDic = timerDic else { return }
        guard let controlsView = controlsView else { return }
        guard let playButton = playButton else { return }
        guard let pauseButton = pauseButton else { return }
        guard let playState = playState else { return }
        
        switch playState {
        case .playing:
            if let count = timerDic["count"] as? Int,
                let progressView = progressView {
                
                // Increment time for label
                
                timerDic["count"] = count + 1
                
                // Update progress bar
                
                progressView.progress += 0.034
                
                if progressView.progress == 1,
                    let currentPlayLengthLabel = currentPlayLengthLabel,
                    let totalPlayLengthLabel = totalPlayLengthLabel {
                    
                    currentPlayLengthLabel.textColor = .white
                    totalPlayLengthLabel.textColor = .orange
                    self.playState = .done
                    timerDic["count"] = 0
                    delegate?.resetPlayerAndSong()
                    controlsView.bringSubview(toFront: playButton)
                    controlsView.sendSubview(toBack: pauseButton)
                    playButton.isEnabled = true
                    pauseButton.isEnabled = false
                    pauseButton.alpha = 0
                    timer = nil
                    progressView.progress = 0
                    
                    UIView.animate(withDuration: 0.5) {
                        if let equalView = self.equalView {
                            self.playButton?.alpha = 1
                            self.equalView?.alpha = 0
                            equalView.stopAnimating()
                        }
                    }
                }
                time = count
                constructTimeString()
            }
        case .done:
            return
        case .paused:
            return
        }
        
    }
    
    func pauseTime() {
        guard let timerDic = timerDic else { return }
        if let count = timerDic["count"] as? Int, let currentPlayLengthLabel = currentPlayLengthLabel {
            timerDic["count"] = count
            currentPlayLengthLabel.text = String(describing: count)
        }
    }
    
    // Toggles thumbs
    
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
    
    // Sets current play time
    
    private func constructTimeString() {
        guard let time = time else { return }
        
        var timeString = String(describing: time)
        var timerString = ""
        if timeString.characters.count < 2 {
            timerString = "0:0\(timeString)"
        } else if timeString.characters.count <= 2 {
            timerString = "0:\(timeString)"
        }
        if let currentPlayLengthLabel = currentPlayLengthLabel {
            currentPlayLengthLabel.text = timerString
        }
        
    }
    
    @objc private func playButtonTapped() {
        
        guard let artworkView = artworkView else { return }
        
        let testFrame: CGRect? = frame
        let color: UIColor? = .gray
        
        equalView = IndicatorView(frame: testFrame, color: color, padding: 0)
        guard let equalView = equalView else { return }
        equalView.alpha = 0.9
        equalView.frame.size = artworkView.frame.size
        equal?.setUpAnimation(in: equalView.layer, color: .blue)
        artworkView.addSubview(equalView)
        equalView.startAnimating()
        
        timer?.invalidate()
        
        if playState == .done, let currentPlayLengthLabel = currentPlayLengthLabel, let totalPlayLengthLabel = totalPlayLengthLabel {
            currentPlayLengthLabel.textColor = .orange
            totalPlayLengthLabel.textColor = .white
        }
        
        playState = .playing
        
        // Timer begin
        
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateTime), userInfo: timerDic, repeats: true)
        
        delegate?.playButtonTapped()
        if let playButton = playButton, let pauseButton = pauseButton, let controlsView = controlsView {
            playButton.isEnabled = false
            playButton.alpha = 0
            pauseButton.isEnabled = true
            pauseButton.alpha = 1
            controlsView.bringSubview(toFront: pauseButton)
            controlsView.sendSubview(toBack: playButton)
        }
    }
    
    @objc private func pauseButtonTapped() {
        guard let equalView = equalView else { return }
        equalView.stopAnimating()
        timer?.invalidate()
        delegate?.pauseButtonTapped()
        if let controlsView = controlsView, let playButton = playButton, let pauseButton = pauseButton {
            controlsView.bringSubview(toFront: playButton)
            controlsView.sendSubview(toBack: pauseButton)
            playButton.isEnabled = true
            playButton.alpha = 1
            pauseButton.isEnabled = false
            pauseButton.alpha = 0
            timer = nil
        }
    }
}
