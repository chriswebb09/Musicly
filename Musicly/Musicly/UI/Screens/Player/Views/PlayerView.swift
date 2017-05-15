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
    
    private var progressIncrementer: Float = 0
    private var progressVisual: Float = 0
    
    // Sets functionality for view from viewModel
    
    var viewModel: PlayerViewModel! {
        didSet {
            currentPlayLengthLabel.textColor = viewModel.currentPlayTimeColor
            totalPlayLengthLabel.textColor = viewModel.totalPlayTimeColor
            progressView.progress = viewModel.progress
            totalPlayLengthLabel.text = viewModel.totalTimeString
            thumbsUpButton.setImage(viewModel.thumbsUpImage, for: .normal)
            thumbsDownButton.setImage(viewModel.thumbsDownImage, for: .normal)
            currentPlayLengthLabel.text = viewModel.defaultTimeString
        }
    }
    
    private var timer: Timer?
    
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
        playButton.setImage(#imageLiteral(resourceName: "playbutton-test"), for: .normal)
        return playButton
    }()
    
    private var pauseButton: UIButton = {
        var pauseButton = UIButton()
        pauseButton.setImage(#imageLiteral(resourceName: "pause-button-test"), for: .normal)
        return pauseButton
    }()
    
    private var progressView: UIProgressView = {
        var progressView = UIProgressView()
        progressView.progressTintColor = .orange
        progressView.observedProgress = Progress(totalUnitCount: 0)
        return progressView
    }()
    
    // Skip and Back buttons
    
    private var skipButton: UIButton = {
        var skipButton = UIButton()
        skipButton.setImage(#imageLiteral(resourceName: "skip-white-hollow-icon"), for: .normal)
        return skipButton
    }()
    
    private var backButton: UIButton = {
        var backButton = UIButton()
        backButton.setImage(#imageLiteral(resourceName: "back-white-hollow"), for: .normal)
        return backButton
    }()
    
    private var totalPlayLengthLabel: UILabel = {
        let label = UILabel()
        if let font = ApplicationConstants.labelFont { label.font = font }
        label.textColor = .white
        label.textAlignment = .right
        return label
    }()
    
    // Time since player started playing
    
    private var currentPlayLengthLabel: UILabel = {
        let label = UILabel()
        // label.text = "0:00"
        label.textAlignment = .left
        if let font = ApplicationConstants.labelFont { label.font = font }
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
    
    // Equalizer
    
    private var equalView: IndicatorView?
    
    private var equalizerView: UIView = {
        let equalizerView = UIView()
        equalizerView.backgroundColor = .clear
        
        return equalizerView
    }()
    
    private var equalizerBackgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .black
        backgroundView.alpha = 0.0
        return backgroundView
    }()
    
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
        infoButton.setImage(#imageLiteral(resourceName: "morebutton"), for: .normal)
        return infoButton
    }()
    
    // MARK: - View logic
    
    override func layoutSubviews() {
        backgroundColor = .appBlue
        setupViews()
        pauseButton.alpha = 0
    }
    
    func playbuttonEnabled(is enabled: Bool) {
        self.playButton.isEnabled = enabled
    }
    
    // Setup PlayerView with viewModel
    
    func configure(with viewModel: PlayerViewModel) {
        playButton.isEnabled = false
        dump(viewModel)
        self.viewModel = viewModel
        self.viewModel.thumbs = .none
      
        if let url = URL(string: viewModel.artworkUrlString) {
            albumArtworkView.downloadImage(url: url)
            trackTitleLabel.text = viewModel.trackName
            albumArtworkView.layer.setCellShadow(contentView: albumArtworkView)
            trackTitleView.layer.setCellShadow(contentView: trackTitleView)
            addSelectors()
        }
    }
    
    // Adds selector methods to buttons
    
    private func addSelectors() {
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        pauseButton.addTarget(self, action: #selector(pauseButtonTapped), for: .touchUpInside)
        thumbsUpButton.addTarget(self, action: #selector(thumbsUpTapped), for: .touchUpInside)
        thumbsDownButton.addTarget(self, action: #selector(thumbsDownTapped), for: .touchUpInside)
        skipButton.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        artistInfoButton.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
    }
    
    func resetProgressAndTime() {
        delegate?.resetPlayerAndSong()
        viewModel.resetProgress()
        viewModel.resetTime()
    }
    
    // Skip and back button functionality
    
    func skipButtonTapped() {
        resetProgressAndTime()
        currentPlayLengthLabel.text = viewModel.defaultTimeString
        delegate?.skipButtonTapped()
        timer?.invalidate()
        switchButton(button: pauseButton, for: playButton)
        stopEqualizer()
    }
    
    func backButtonTapped() {
        resetProgressAndTime()
        timer?.invalidate()
        currentPlayLengthLabel.text = viewModel.defaultTimeString
        delegate?.backButtonTapped()
        switchButton(button: pauseButton, for: playButton)
        stopEqualizer()
    }
    
    func setPlayState(state: FileState) {
        viewModel.playState = state
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
    
    private func setupEqualizerView() {
        artworkView.addSubview(equalizerView)
        equalizerView.translatesAutoresizingMaskIntoConstraints = false
        equalizerView.widthAnchor.constraint(equalTo: artworkView.widthAnchor).isActive = true
        equalizerView.topAnchor.constraint(equalTo: artworkView.topAnchor).isActive = true
        equalizerView.heightAnchor.constraint(equalTo: artworkView.heightAnchor, multiplier: 0.08).isActive = true
    }
    
    private func setupEqualizerBackgroundView() {
        equalizerView.addSubview(equalizerBackgroundView)
        equalizerBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        equalizerBackgroundView.heightAnchor.constraint(equalTo: equalizerView.heightAnchor).isActive = true
        equalizerBackgroundView.widthAnchor.constraint(equalTo: equalizerView.widthAnchor).isActive = true
        equalizerBackgroundView.centerXAnchor.constraint(equalTo: equalizerView.centerXAnchor).isActive = true
        equalizerBackgroundView.centerYAnchor.constraint(equalTo: equalizerView.centerYAnchor).isActive = true
    }
    
    // MARK: - Preferences setup
    
    private func setupPreferencesView() {
        addSubview(preferencesView)
        preferencesView.translatesAutoresizingMaskIntoConstraints = false
        preferencesView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        preferencesView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: PlayerViewConstants.preferenceHeightMultiplier).isActive = true
        preferencesView.topAnchor.constraint(equalTo: artworkView.bottomAnchor).isActive = true
    }
    
    private func setupArtistBioButton() {
        preferencesView.addSubview(artistInfoButton)
        artistInfoButton.translatesAutoresizingMaskIntoConstraints = false
        artistInfoButton.widthAnchor.constraint(equalTo: preferencesView.widthAnchor, multiplier: PlayerViewConstants.artistInfoWidthMultiplier).isActive = true
        artistInfoButton.heightAnchor.constraint(equalTo: preferencesView.heightAnchor, multiplier: PlayerViewConstants.artistInfoHeightMultiplier).isActive = true
        artistInfoButton.rightAnchor.constraint(equalTo: preferencesView.rightAnchor, constant: UIScreen.main.bounds.width * PlayerViewConstants.artistInfoRightOffset).isActive = true
        artistInfoButton.centerYAnchor.constraint(equalTo: preferencesView.centerYAnchor).isActive = true
    }
    
    // Thumbs
    
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
        button.heightAnchor.constraint(equalTo: controlsView.heightAnchor, multiplier: 0.23).isActive = true
        button.centerYAnchor.constraint(equalTo: controlsView.centerYAnchor, constant: UIScreen.main.bounds.height * -0.05).isActive = true
        button.centerXAnchor.constraint(equalTo: controlsView.centerXAnchor).isActive = true
    }
    
    // Skip and back button
    
    private func setupSkipButtons() {
        skipButtonsSharedLayout(button: skipButton)
        skipButton.rightAnchor.constraint(equalTo: controlsView.rightAnchor, constant: UIScreen.main.bounds.width * -0.15).isActive = true
        skipButton.centerYAnchor.constraint(equalTo: controlsView.centerYAnchor, constant: UIScreen.main.bounds.height * -0.05).isActive = true
        skipButtonsSharedLayout(button: backButton)
        backButton.leftAnchor.constraint(equalTo: controlsView.leftAnchor, constant: UIScreen.main.bounds.width * 0.15).isActive = true
        backButton.centerYAnchor.constraint(equalTo: controlsView.centerYAnchor, constant: UIScreen.main.bounds.height * -0.05).isActive = true
    }
    
    private func skipButtonsSharedLayout(button: UIButton) {
        controlsView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalTo: controlsView.widthAnchor, multiplier: PlayerViewConstants.backButtonWidthMultiplier).isActive = true
        button.heightAnchor.constraint(equalTo: controlsView.heightAnchor, multiplier: PlayerViewConstants.backButtonHeightMultiplier).isActive = true
    }
    
    // Kicks off Equalizer animation sequence
    
    private func startEqualizer() {
        equalView = IndicatorView(frame: equalizerView.frame, color: .gray, padding: 0)
        guard let equalView = equalView else { return }
        equalView.alpha = 0.8
        equalView.frame.size = equalizerView.frame.size
        equalizerView.addSubview(equalView)
        equalizerBackgroundView.alpha = 0.5
        equalView.startAnimating()
    }
    
    // Setups up play and pause buttons
    
    private func setupControlButtons() {
        setupTrackButtons(button: playButton)
        playButton.widthAnchor.constraint(equalTo: controlsView.widthAnchor, multiplier: 0.22).isActive = true
        setupTrackButtons(button: pauseButton)
        pauseButton.widthAnchor.constraint(equalTo: controlsView.widthAnchor, multiplier: 0.22).isActive = true
    }
    
    private func setupProgressView() {
        controlsView.addSubview(progressView)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.widthAnchor.constraint(equalTo: controlsView.widthAnchor, multiplier: PlayerViewConstants.progressViewWidthMultiplier).isActive = true
        progressView.heightAnchor.constraint(equalTo: controlsView.heightAnchor, multiplier: PlayerViewConstants.progressViewHeightMultiplier).isActive = true
        progressView.centerXAnchor.constraint(equalTo: controlsView.centerXAnchor).isActive = true
        progressView.centerYAnchor.constraint(equalTo: controlsView.centerYAnchor, constant: UIScreen.main.bounds.height * -0.16).isActive = true
    }
    
    private func setupTimeLengthLabels() {
        timeLabelsSharedLayout(timeLabel: totalPlayLengthLabel)
        totalPlayLengthLabel.rightAnchor.constraint(equalTo: controlsView.rightAnchor, constant: UIScreen.main.bounds.width * -0.07).isActive = true
        timeLabelsSharedLayout(timeLabel: currentPlayLengthLabel)
        currentPlayLengthLabel.leftAnchor.constraint(equalTo: controlsView.leftAnchor, constant: UIScreen.main.bounds.width * 0.07).isActive = true
    }
    
    private func timeLabelsSharedLayout(timeLabel: UILabel) {
        controlsView.addSubview(timeLabel)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.heightAnchor.constraint(equalTo: controlsView.heightAnchor, multiplier: PlayerViewConstants.playTimeLabelHeightMutliplier).isActive = true
        timeLabel.widthAnchor.constraint(equalTo: controlsView.widthAnchor, multiplier: 0.15).isActive = true
        timeLabel.centerYAnchor.constraint(equalTo: controlsView.centerYAnchor, constant: UIScreen.main.bounds.height * -0.16).isActive = true
    }
    
    // Stops equalizer animations
    
    private func stopEqualizer() {
        equalizerBackgroundView.alpha = 0
        equalView?.stopAnimating()
    }
    
    @objc private func moreButtonTapped() {
        delegate?.moreButtonTapped()
    }
    
    // Configures all subview
    
    private func setupViews() {
        setupTrackTitleView()
        setupArtworkView()
        setupAlbumArtworkView()
        setupEqualizerView()
        setupEqualizerBackgroundView()
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
    
    func setupTimeLabels(totalTime: String?, timevalue: Float) {
        guard let totalTime = totalTime else { return }
        progressIncrementer = timevalue / 920
        viewModel.totalTimeString = totalTime
    }
    
    // Gives values to progress bar
    
    func updateProgressBar(value: Double) {
        let floatValue = Float(value)
        viewModel.progress += floatValue
    }
    
    @objc private func updateTime() {
        switch viewModel.playState {
        case .queued:
            return
        case .playing:
            guard let countDict = timer?.userInfo as? NSMutableDictionary else { return }
            guard var count = countDict["count"] as? Int else { return }
            viewModel.time = count + 1
            progressView.progress += progressIncrementer
            viewModel.progress = progressView.progress
            countDict["count"] = viewModel.time
            currentPlayLengthLabel.text = String.constructTimeString(time: viewModel.time)
            if progressView.progress == 1 {
                finishedPlaying(countDict: countDict, time: 0)
            }
        case .done:
            return
        case .paused:
            return
        }
    }
    
    // On song completed playing
    
    private func finishedPlaying(countDict: NSMutableDictionary?, time: Int) {
        viewModel.playState = .done
        
        countDict?["count"] = time
        delegate?.resetPlayerAndSong()
        viewModel.resetTime()
        currentPlayLengthLabel.text = "0:00"
        switchButton(button: pauseButton, for: playButton)
        viewModel.resetProgress()
        stopEqualizer()
        timer?.invalidate()
    }
    
    // Animate disappearance of Equalizer
    
    private func animateEqualizer() {
        UIView.animate(withDuration: 0.5) {
            self.playButton.alpha = 1
            self.equalView?.alpha = 0
            self.stopEqualizer()
        }
    }
    
    private func pauseTime() {
        if let countDict = timer?.userInfo as? NSMutableDictionary?,
            let count = countDict?["count"] as? Int {
            countDict?["count"] = count
            viewModel.time = count
            currentPlayLengthLabel.text = String(describing: count)
            timer?.invalidate()
        }
    }
    
    @objc private func thumbsUpTapped() {
        viewModel.thumbs = .up
        delegate?.thumbsUpTapped()
    }
    
    @objc private func thumbsDownTapped() {
        viewModel.thumbs = .down
        delegate?.thumbsDownTapped()
    }
    
    // Timer
    
    private func setTimer() {
        timer?.invalidate()
        let timerDic: NSMutableDictionary = ["count": viewModel.time]
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: timerDic, repeats: true)
    }
    
    @objc private func playButtonTapped() {
        setTimer()
        startEqualizer()
        viewModel.playState = .playing
        delegate?.playButtonTapped()
        switchButton(button: playButton, for: pauseButton)
    }
    
    @objc private func pauseButtonTapped() {
        viewModel.playState = .paused
        stopEqualizer()
        pauseTime()
        delegate?.pauseButtonTapped()
        currentPlayLengthLabel.text = String.constructTimeString(time: viewModel.time)
        switchButton(button: pauseButton, for: playButton)
    }
    
    // Toggles play and pause button
    
    private func switchButton(button: UIButton?, for currentButton: UIButton?) {
        guard let button = button, let currentButton = currentButton else { return }
        controlsView.bringSubview(toFront: currentButton)
        controlsView.sendSubview(toBack: button)
        currentButton.isEnabled = true
        currentButton.alpha = 1
        button.isEnabled = false
        button.alpha = 0
    }
}
