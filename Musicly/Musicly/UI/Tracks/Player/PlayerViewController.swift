//
//  PlayerViewController.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 4/12/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit
import AVFoundation

final class PlayerViewController: UIViewController {
    
    var playerView: PlayerView = PlayerView()
    var track: iTrack?
    
    lazy var player: AVPlayer = {
        return AVPlayer()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []
        view.addSubview(playerView)
        playerView.frame = UIScreen.main.bounds
        playerView.layoutSubviews()
        playerView.delegate = self
        if let track = track {
            playerView.configure(with: track)
        }
        title = track?.artistName
        if let urlString = track?.previewUrl, let url = URL(string: urlString) {
            setupPlayer(url: url)
            
        }
        if let currentItem = player.currentItem {
            playerView.setupTime(time: currentItem.duration)
        }
    }
    
    private func setupPlayer(url: URL) {
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        player.rate = PlayerAttributes.playerRate
        player.pause()
    }
}

extension PlayerViewController: PlayerViewDelegate {
    func thumbsDownTapped() {
        track?.thumbs = .down
         print("thumbs down")
    }

    func thumbsUpTapped() {
        track?.thumbs = .up
        print("thumbs up")
    }

    
    func pauseButtonTapped() {
        print("pause")
        player.pause()
    }
    
    func playButtonTapped() {
        player.play()
    }
    
    func downloadButtonTapped() {
        print("Downloading")
    }
}
