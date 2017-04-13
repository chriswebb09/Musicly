//
//  PlayerViewController.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 4/12/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit
import AVFoundation

class PlayerViewController: UIViewController {
    
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
    }
}

extension PlayerViewController: PlayerViewDelegate {
    
    private func setupPlayer(url: URL) {
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        player.rate = PlayerAttributes.playerRate
    }
    
    func pauseButtonTapped() {
        print("pause")
        player.pause()
    }
    
    func playButtonTapped() {
        if let urlString = track?.previewUrl, let url = URL(string: urlString) {
            setupPlayer(url: url)
        }
        player.play()
    }
    
    func downloadButtonTapped() {
        print("Downloading")
    }
}
