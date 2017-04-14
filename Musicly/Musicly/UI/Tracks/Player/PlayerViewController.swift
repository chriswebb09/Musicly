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
    
    var player: AVPlayer?
    
    var avUrlAsset: AVURLAsset?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        player = AVPlayer()
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
            playerView.setupTimeLabels(totalTime: fileTime)
        }
    }
    
    
    func getFileTime(url: URL) -> String? {
        avUrlAsset = AVURLAsset(url: url)
        if let asset = avUrlAsset {
            if let player = player {
                let audioDuration = asset.duration
                let audioDurationSeconds = CMTimeGetSeconds(audioDuration)
                let minutes = Int(audioDurationSeconds / 60)
                let rem = Int(audioDurationSeconds.truncatingRemainder(dividingBy: 60))
                return "\(minutes):\(rem)"
            }
        }
        return nil
    }
    
    
    
    private func setupPlayer(url: URL) {
        avUrlAsset = AVURLAsset(url: url)
        let item = AVPlayerItem(asset: avUrlAsset!)
        player = AVPlayer(playerItem: item)
        if let player = player {
            player.rate = PlayerAttributes.playerRate
            player.pause()
        }
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
        player?.pause()
    }
    
    func playButtonTapped() {
        if let player = player {
            let audioDuration = avUrlAsset!.duration
            let audioDurationSeconds = CMTimeGetSeconds(audioDuration)
            let minutes = Int(audioDurationSeconds / 60)
            let rem = Int(audioDurationSeconds.truncatingRemainder(dividingBy: 60))
            playerView.setupTimeLabels(totalTime: "\(minutes):\(rem)")
            player.play()
        }
    }
    
    func downloadButtonTapped() {
        print("Downloading")
    }
}
