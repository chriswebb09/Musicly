//
//  PlayerViewController.swift
//  Musicly
//
// Credit: https://github.com/ninjaprox/NVActivityIndicatorView

import UIKit
import AVFoundation

final class PlayerViewController: UIViewController {
    
    var player: AVPlayer?
    var playerView: PlayerView? = PlayerView()
    var track: iTrack?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []
        view.addSubview(playerView!)
        playerView?.frame = UIScreen.main.bounds
        playerView?.layoutSubviews()
        playerView?.delegate = self
        if let track = track {
            playerView?.configure(with: track.artworkUrl, trackName: track.trackName)
        }
        title = track?.artistName
        if let urlString = track?.previewUrl, let url = URL(string: urlString), let fileTime = getFileTime(url: url) {
            playerView?.setupTimeLabels(totalTime: fileTime)
        }
    }
    
    deinit {
        playerView = nil
        track = nil
        dump(self)
    }
    // Gets total time length for song
    
    func getFileTime(url: URL) -> String? {
        
        var avUrlAsset: AVURLAsset? = AVURLAsset(url: url)
        if let asset = avUrlAsset {
            let audioDuration = asset.duration
            let audioDurationSeconds = CMTimeGetSeconds(audioDuration)
            let minutes = Int(audioDurationSeconds / 60)
            let rem = Int(audioDurationSeconds.truncatingRemainder(dividingBy: 60))
            
            avUrlAsset = nil
            return "\(minutes):\(rem)"
        }
        return nil
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopPlayer()
        dump(playerView)
        playerView?.removeFromSuperview()
        playerView = nil
        dump(playerView)
    }
    
    func initPlayer(url: URL)  {
        if let play = player {
            print("playing")
            play.play()
        } else {
            print("player allocated")
            player = AVPlayer(url: url)
            print("playing")
            player!.play()
        }
    }
    
    func initPlayer(nsURL: URL)  {
        do {
            player = try AVPlayer(url: nsURL)
            guard let player = player else { return }
            player.rate = 1
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
}

extension PlayerViewController: PlayerViewDelegate {
    func pauseButtonTapped() {
        stopPlayer()
        print("pause")
    }
    
    
    func resetPlayerAndSong() {
        print("reset")
        stopPlayer()
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
    
    func stopPlayer() {
        do {
            player = nil
            guard player == nil else { fatalError("Player is not nil") }
        }
    }
    
    func playButtonTapped() {
        if let urlString = track?.previewUrl {
            initPlayer(nsURL: URL(string: urlString)!)
        }
    }
}

