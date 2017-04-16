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
    var player: AVPlayer = AVPlayer()
    var avUrlAsset: AVURLAsset?
    
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
        if let urlString = track?.previewUrl, let url = URL(string: urlString), let fileTime = getFileTime(url: url) {
            player.setupWithItem(itemUrl: url)
            playerView.setupTimeLabels(totalTime: fileTime)
        }
    }
    
    // Gets total time length for song 
    // TODO: - This can be implemented better
    
    func getFileTime(url: URL) -> String? {
        avUrlAsset = AVURLAsset(url: url)
        if let asset = avUrlAsset {
            let audioDuration = asset.duration
            let audioDurationSeconds = CMTimeGetSeconds(audioDuration)
            let minutes = Int(audioDurationSeconds / 60)
            let rem = Int(audioDurationSeconds.truncatingRemainder(dividingBy: 60))
            return "\(minutes):\(rem)"
        }
        return nil
    }
}

extension PlayerViewController: PlayerViewDelegate {
    
    // TODO: - This can be implemented better
    // Resets song to beginning when player reaches end
    
    func resetPlayerAndSong() {
        if let urlString = track?.previewUrl, let url = URL(string: urlString), let fileTime = getFileTime(url: url) {
            player.setupWithItem(itemUrl: url)
            playerView.setupTimeLabels(totalTime: fileTime)
        }
        player.currentItem?.seek(to: kCMTimeZero)
        player.rate = PlayerAttributes.playerRate
        player.pause()
    }
    
    // MARK: - Thumbs
    
    func thumbsDownTapped() {
        track?.thumbs = .down
        print("thumbs down")
    }
    
    func thumbsUpTapped() {
        track?.thumbs = .up
        print("thumbs up")
    }
    
    // MARK: - Player controlers
    
    func pauseButtonTapped() {
        print("pause")
        player.pause()
    }
    
    func playButtonTapped() {
        player.play()
    }
}
