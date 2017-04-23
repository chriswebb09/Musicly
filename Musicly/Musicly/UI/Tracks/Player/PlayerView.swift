//
//  PlayerView.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 4/12/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

final class PlayerView: UIView {
    
    weak var delegate: PlayerViewDelegate?
    private var timer: Timer?
    private var playState: FileState? {
        didSet {
            currentPlayLengthLabel.textColor = playState == .done ? .white : .orange
            totalPlayLengthLabel.textColor = playState == .playing ? .white : .orange
            if playState == .playing {
                startEqualizer()
            } else if playState == .done {
                time = 0
                stopEqualizer()
            } else {
                stopEqualizer()
            }
        }
    }
    private var time: Int? = 0
    private var thumbs: Thumbs? = .none
    
    // MARK: - Cover art
    
    private var albumArtworkView: UIImageView = {
        var albumArtworkView = UIImageView()
        albumArtworkView.backgroundColor = .clear
        return albumArtworkView
    }()
    
    private var artworkView: UIView = {
        var artworkView = UIView()
        artworkView.backgroundColor = .appBlue
        return artworkView
    }()
    
    // MARK: - Music controls
    
    private var controlsView: UIView = {
        let controlsView = UIView()
        controlsView.backgroundColor = .textColor
        return controlsView
    }()
    
    private var playButton: UIButton = {
        var playButton = UIButton()
        playButton.setImage(#imageLiteral(resourceName: "whitetriangleplay"), for: .normal)
        if let imageView = playButton.imageView {
            imageView.layer.setViewShadow(view: imageView)
            imageView.layer.shadowPath = UIBezierPath(roundedRect: imageView.bounds,
                                                      cornerRadius: imageView.layer.cornerRadius).cgPath
        }
        return playButton
    }()
    
    private var pauseButton: UIButton = {
        var pauseButton = UIButton()
        pauseButton.setImage(#imageLiteral(resourceName: "pausebutton-2white"), for: .normal)
        if let imageView = pauseButton.imageView {
            imageView.layer.setViewShadow(view: imageView)
            imageView.layer.shadowPath = UIBezierPath(roundedRect: pauseButton.bounds,
                                                      cornerRadius: imageView.layer.cornerRadius).cgPath
        }
        return pauseButton
    }()
    
    private var progressView: UIProgressView = {
        var progressView = UIProgressView()
        progressView.progress = 0.0
        progressView.progressTintColor = .orange
        progressView.observedProgress = Progress(totalUnitCount: 0)
        return progressView
    }()
    
    private var skipButton: UIButton = {
        var skipButton = UIButton()
        skipButton.setImage(#imageLiteral(resourceName: "skipiconwhite"), for: .normal)
        if let imageView = skipButton.imageView {
            imageView.layer.setViewShadow(view: imageView)
            imageView.layer.shadowPath = UIBezierPath(roundedRect: imageView.bounds,
                                                      cornerRadius: imageView.layer.cornerRadius).cgPath
        }
        return skipButton
    }()
    
    private var backButton: UIButton = {
        var backButton = UIButton()
        backButton.setImage(#imageLiteral(resourceName: "backiconwhite"), for: .normal)
        if let imageView = backButton.imageView {
            imageView.layer.setViewShadow(view: imageView)
            imageView.layer.shadowPath = UIBezierPath(roundedRect: imageView.bounds,
                                                      cornerRadius: imageView.layer.cornerRadius).cgPath
        }
        return backButton
    }()
    
    private var totalPlayLengthLabel: UILabel = {
        let label = UILabel()
        if let font = ApplicationConstants.mainFont { label.font = font }
        label.textColor = .white
        label.textAlignment = .right
        return label
    }()
    
    // Time since player started playing
    
    private var currentPlayLengthLabel: UILabel = {
        let label = UILabel()
        label.text = "0:00"
        label.textAlignment = .left
        if let font = ApplicationConstants.mainFont { label.font = font }
        label.textColor = .orange
        return label
    }()
    
    // MARK: - Track title
    
    private var trackTitleView: UIView = {
        let trackTitleView = UIView()
        trackTitleView.backgroundColor = .white
        return trackTitleView
    }()
    
    private  var trackTitleLabel: UILabel = {
        var trackTitleLabel = UILabel()
        trackTitleLabel.textColor = .textColor
        trackTitleLabel.textAlignment = .center
        return trackTitleLabel
    }()
    
    // MARK: - Preferences
    
    private var preferencesView: UIView = {
        let preferencesView = UIView()
        preferencesView.backgroundColor = .white
        return preferencesView
    }()
    
    private var equalView: IndicatorView?
    
    private var thumbsUpButton: UIButton = {
        let thumbsUpButton = UIButton()
        thumbsUpButton.setImage(#imageLiteral(resourceName: "thumbsupblue"), for: .normal)
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
        infoButton.setTitleColor(.textColor, for: .normal)
        return infoButton
    }()
    
    // MARK: - View logic
    
    override func layoutSubviews() {
        backgroundColor = .appBlue
        setupViews()
        pauseButton.alpha = 0
    }
    
    func configure(with artworkUrl: String?, trackName: String?, thumbs: Thumbs) {
        if let artworkUrl = artworkUrl,
            let url = URL(string: artworkUrl),
            let trackName = trackName {
            albumArtworkView.downloadImage(url: url)
            trackTitleLabel.text = trackName
            albumArtworkView.layer.setCellShadow(contentView: albumArtworkView)
            trackTitleView.layer.setCellShadow(contentView: trackTitleView)
            playButton.layer.setViewShadow(view: playButton)
            addSelectors()
            DispatchQueue.main.async {
                self.switchThumbs()
            }
        }
    }
    
    private func addSelectors() {
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        pauseButton.addTarget(self, action: #selector(pauseButtonTapped), for: .touchUpInside)
        thumbsUpButton.addTarget(self, action: #selector(thumbsUpTapped), for: .touchUpInside)
        thumbsDownButton.addTarget(self, action: #selector(thumbsDownTapped), for: .touchUpInside)
        skipButton.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    func resetProgressAndTime() {
        delegate?.resetPlayerAndSong()
        progressView.progress = 0
        time = 0
    }
    
    func skipButtonTapped() {
        resetProgressAndTime()
        delegate?.skipButtonTapped()
    }
    
    func backButtonTapped() {
        resetProgressAndTime()
        delegate?.backButtonTapped()
    }
    
    func setPlayState(state: FileState) {
        playState = state
    }
    
    private func setupTrackTitleView() {
        addSubview(trackTitleView)
        trackTitleView.translatesAutoresizingMaskIntoConstraints = false
        trackTitleView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        trackTitleView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: PlayerViewConstants.trackTitleViewHeightMultiplier).isActive = true
        trackTitleView.topAnchor.constraint(equalTo: topAnchor).isActive = true
    }
    
    func sharedTitleArtLayout(view: UIView) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    }
    
    private func setupTrackTitleLabel() {
        trackTitleView.addSubview(trackTitleLabel)
        trackTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        trackTitleLabel.widthAnchor.constraint(equalTo: trackTitleView.widthAnchor).isActive = true
        trackTitleLabel.heightAnchor.constraint(equalTo: trackTitleView.heightAnchor, multiplier: PlayerViewConstants.trackTitleLabelHeightMultiplier).isActive = true
        trackTitleLabel.centerYAnchor.constraint(equalTo: trackTitleView.centerYAnchor, constant: controlsView.bounds.height * PlayerViewConstants.trackTitleLabelCenterYOffset).isActive = true
    }
    
    // MARK: - Cover art setup
    
    private func setupArtworkView() {
        sharedTitleArtLayout(view: artworkView)
        artworkView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: PlayerViewConstants.artworkViewHeightMultiplier).isActive = true
        artworkView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        artworkView.topAnchor.constraint(equalTo: trackTitleView.bottomAnchor).isActive = true
    }
    
    private func setupAlbumArtworkView() {
        artworkView.addSubview(albumArtworkView)
        albumArtworkView.translatesAutoresizingMaskIntoConstraints = false
        albumArtworkView.widthAnchor.constraint(equalTo: artworkView.widthAnchor, multiplier: PlayerViewConstants.albumWidthMultiplier).isActive = true
        albumArtworkView.heightAnchor.constraint(equalTo: artworkView.heightAnchor, multiplier: PlayerViewConstants.albumHeightMultiplier).isActive = true
        albumArtworkView.centerXAnchor.constraint(equalTo: artworkView.centerXAnchor).isActive = true
        albumArtworkView.centerYAnchor.constraint(equalTo: artworkView.centerYAnchor).isActive = true
    }
    
    private func setupPreferencesView() {
        addSubview(preferencesView)
        preferencesView.translatesAutoresizingMaskIntoConstraints = false
        preferencesView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        preferencesView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: PlayerViewConstants.preferencedHeightMultiplier).isActive = true
        preferencesView.topAnchor.constraint(equalTo: artworkView.bottomAnchor).isActive = true
    }
    
    // MARK: - Preferences setup
    
    private func setupArtistBioButton() {
        preferencesView.addSubview(artistInfoButton)
        artistInfoButton.translatesAutoresizingMaskIntoConstraints = false
        artistInfoButton.widthAnchor.constraint(equalTo: preferencesView.widthAnchor, multiplier: PlayerViewConstants.artistInfoWidthMultiplier).isActive = true
        artistInfoButton.heightAnchor.constraint(equalTo: preferencesView.heightAnchor, multiplier: PlayerViewConstants.artistInfoHeightMultiplier).isActive = true
        artistInfoButton.rightAnchor.constraint(equalTo: preferencesView.rightAnchor, constant: UIScreen.main.bounds.width * PlayerViewConstants.artistInfoRightOffset).isActive = true
        artistInfoButton.centerYAnchor.constraint(equalTo: preferencesView.centerYAnchor).isActive = true
    }
    
    private func setupThumbsUpButton() {
        thumbsButtonSetup(thumbs: thumbsUpButton)
        thumbsUpButton.leftAnchor.constraint(equalTo: preferencesView.leftAnchor, constant: UIScreen.main.bounds.width * PlayerViewConstants.thumbsUpLeftOffset).isActive = true
        thumbsUpButton.centerYAnchor.constraint(equalTo: preferencesView.centerYAnchor).isActive = true
    }
    
    private func setupThumbsDownButton() {
        thumbsButtonSetup(thumbs: thumbsDownButton)
        thumbsDownButton.leftAnchor.constraint(equalTo: preferencesView.leftAnchor, constant: UIScreen.main.bounds.width * PlayerViewConstants.thumbsDownLeftOffset).isActive = true
        thumbsDownButton.centerYAnchor.constraint(equalTo: preferencesView.centerYAnchor).isActive = true
    }
    
    private func thumbsButtonSetup(thumbs: UIButton?) {
        guard let thumbs = thumbs else { return }
        preferencesView.addSubview(thumbs)
        thumbs.translatesAutoresizingMaskIntoConstraints = false
        thumbs.widthAnchor.constraint(equalTo: preferencesView.widthAnchor, multiplier: PlayerViewConstants.thumbsWidthMultiplier).isActive = true
        thumbs.heightAnchor.constraint(equalTo: preferencesView.heightAnchor, multiplier: PlayerViewConstants.thumbsHeightMultplier).isActive = true
    }
    
    // MARK: - Music controls setup
    
    private func setupControlsView() {
        addSubview(controlsView)
        controlsView.translatesAutoresizingMaskIntoConstraints = false
        controlsView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        controlsView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: PlayerViewConstants.controlsViewHeightMultiplier).isActive = true
        controlsView.topAnchor.constraint(equalTo: preferencesView.bottomAnchor).isActive = true
    }
    
    private func setupTrackButtons(button: UIButton) {
        controlsView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalTo: controlsView.widthAnchor, multiplier: 0.16).isActive = true
        button.heightAnchor.constraint(equalTo: controlsView.heightAnchor, multiplier: 0.14).isActive = true
        button.centerXAnchor.constraint(equalTo: controlsView.centerXAnchor, constant: UIScreen.main.bounds.width * 0.025).isActive = true
        button.centerYAnchor.constraint(equalTo: controlsView.centerYAnchor, constant: UIScreen.main.bounds.height * PlayerViewConstants.backButtonCenterYOffset).isActive = true
    }
    
    private func setupSkipButtons() {
        skipButtonsSharedLayout(button: skipButton)
        skipButton.rightAnchor.constraint(equalTo: controlsView.rightAnchor, constant: UIScreen.main.bounds.width * -0.15).isActive = true
        skipButton.centerYAnchor.constraint(equalTo: controlsView.centerYAnchor, constant: UIScreen.main.bounds.height * PlayerViewConstants.backButtonCenterYOffset).isActive = true
        skipButtonsSharedLayout(button: backButton)
        backButton.leftAnchor.constraint(equalTo: controlsView.leftAnchor, constant: UIScreen.main.bounds.width * 0.15).isActive = true
        backButton.centerYAnchor.constraint(equalTo: controlsView.centerYAnchor, constant: UIScreen.main.bounds.height * PlayerViewConstants.backButtonCenterYOffset).isActive = true
    }
    
    func skipButtonsSharedLayout(button: UIButton) {
        controlsView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalTo: controlsView.widthAnchor, multiplier: PlayerViewConstants.backButtonWidthMultiplier).isActive = true
        button.heightAnchor.constraint(equalTo: controlsView.heightAnchor, multiplier: PlayerViewConstants.backButtonHeightMultiplier).isActive = true
    }
    
    func startEqualizer() {
        equalView = IndicatorView(frame: frame, color: .gray, padding: 0)
        guard let equalView = equalView else { return }
        equalView.alpha = 0.9
        equalView.frame.size = artworkView.frame.size
        artworkView.addSubview(equalView)
        equalView.startAnimating()
    }
    
    func stopEqualizer() {
        equalView?.stopAnimating()
    }
    
    private func setupControlButtons() {
        setupTrackButtons(button: playButton)
        setupTrackButtons(button: pauseButton)
    }
    
    private func setupProgressView() {
        controlsView.addSubview(progressView)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.widthAnchor.constraint(equalTo: controlsView.widthAnchor, multiplier: PlayerViewConstants.progressViewWidthMultiplier).isActive = true
        progressView.heightAnchor.constraint(equalTo: controlsView.heightAnchor, multiplier: PlayerViewConstants.progressViewHeightMultiplier).isActive = true
        progressView.centerXAnchor.constraint(equalTo: controlsView.centerXAnchor).isActive = true
        progressView.centerYAnchor.constraint(equalTo: controlsView.centerYAnchor, constant: UIScreen.main.bounds.height * -0.2).isActive = true
    }
    
    private func setupTimeLengthLabels() {
        timeLabelsSharedLayout(timeLabel: totalPlayLengthLabel)
        totalPlayLengthLabel.rightAnchor.constraint(equalTo: controlsView.rightAnchor, constant: UIScreen.main.bounds.width * -0.07).isActive = true
        timeLabelsSharedLayout(timeLabel: currentPlayLengthLabel)
        currentPlayLengthLabel.leftAnchor.constraint(equalTo: controlsView.leftAnchor, constant: UIScreen.main.bounds.width * 0.07).isActive = true
    }
    
    func timeLabelsSharedLayout(timeLabel: UILabel) {
        controlsView.addSubview(timeLabel)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.heightAnchor.constraint(equalTo: controlsView.heightAnchor, multiplier: PlayerViewConstants.playTimeLabelHeightMutliplier).isActive = true
        timeLabel.widthAnchor.constraint(equalTo: controlsView.widthAnchor, multiplier: 0.15).isActive = true
        timeLabel.centerYAnchor.constraint(equalTo: controlsView.centerYAnchor, constant: UIScreen.main.bounds.height * -0.2).isActive = true
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
        setupControlButtons()
        setupSkipButtons()
        setupProgressView()
        setupTimeLengthLabels()
    }
    
    // Changes thumb button images depending on selection
    
    private func switchThumbs() {
        thumbs == .down ? thumbsDownButton.setImage(#imageLiteral(resourceName: "thumbsdownorange"), for: .normal) : thumbsDownButton.setImage(#imageLiteral(resourceName: "thumbsdownblue"), for: .normal)
        thumbs == .up ? thumbsUpButton.setImage(#imageLiteral(resourceName: "thumbsupiconorange"), for: .normal) : thumbsUpButton.setImage(#imageLiteral(resourceName: "thumbsupblue"), for: .normal)
        if thumbs == .none {
            thumbsUpButton.setImage(#imageLiteral(resourceName: "thumbsupblue"), for: .normal)
            thumbsDownButton.setImage(#imageLiteral(resourceName: "thumbsdownblue"), for: .normal)
        }
    }
    
    func setupTimeLabels(totalTime: String?) {
        if let totalTime = totalTime {
            totalPlayLengthLabel.text = totalTime
        }
    }
    
    func updateProgressBar(value: Double) {
        let floatValue = Float(value)
        progressView.progress += floatValue
    }
    
    @objc private func updateTime() {
        guard let playState = playState else { return }
        switch playState {
        case .playing:
            if var time = time, let countDict = timer?.userInfo as? NSMutableDictionary?,
                let count = countDict?["count"] as? Int {
                time = count + 1
                countDict?["count"] = time
                currentPlayLengthLabel.text = String.constructTimeString(time: time)
                if progressView.progress == 1 {
                    finishedPlaying(countDict: countDict)
                }
            }
        case .done:
            return
        case .paused:
            return
        }
    }
    
    func finishedPlaying(countDict: NSMutableDictionary?) {
        playState = .done
        countDict?["count"] = time
        delegate?.resetPlayerAndSong()
        switchButton(button: pauseButton, for: playButton)
        timer = nil
        progressView.progress = 0
        animateEqualizer()
        
    }
    
    func animateEqualizer() {
        UIView.animate(withDuration: 0.5) {
            if let equalView = self.equalView {
                self.playButton.alpha = 1
                self.equalView?.alpha = 0
                self.stopEqualizer()
            }
        }
    }
    
    func pauseTime() {
        if let countDict = timer?.userInfo as? NSMutableDictionary?,
            let count = countDict?["count"] as? Int {
            countDict?["count"] = count
            time = count
            currentPlayLengthLabel.text = String(describing: count)
            timer?.invalidate()
        }
    }
    
    // Toggles thumbs
    
    @objc private func thumbsUpTapped() {
        thumbs = .up
        switchThumbs()
        delegate?.thumbsUpTapped()
    }
    
    @objc private func thumbsDownTapped() {
        thumbs = .down
        switchThumbs()
        delegate?.thumbsDownTapped()
    }
    
    func setTimer() {
        timer?.invalidate()
        guard let time = time else { return }
        let timerDic: NSMutableDictionary = ["count": time]
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: timerDic, repeats: true)
    }
    
    @objc private func playButtonTapped() {
        delegate?.playButtonTapped()
        switchButton(button: playButton, for: pauseButton)
    }
    
    @objc private func pauseButtonTapped() {
        pauseTime()
        delegate?.pauseButtonTapped()
        guard let time = time else { return }
        currentPlayLengthLabel.text = String.constructTimeString(time: time)
        switchButton(button: pauseButton, for: playButton)
    }
    
    func switchButton(button: UIButton?, for currentButton: UIButton?) {
        guard let button = button, let currentButton = currentButton else { return }
        controlsView.bringSubview(toFront: currentButton)
        controlsView.sendSubview(toBack: button)
        currentButton.isEnabled = true
        currentButton.alpha = 1
        button.isEnabled = false
        button.alpha = 0
    }
}
