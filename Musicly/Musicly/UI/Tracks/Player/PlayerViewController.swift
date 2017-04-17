//
//  PlayerViewController.swift
//  Musicly


import UIKit
import AVFoundation

final class PlayerViewController: UIViewController {
    
    var player: AVPlayer?
    var playerView: PlayerView? = PlayerView()
    var track: iTrack?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []
        if let playerView = playerView, let track = track {
            view.addSubview(playerView)
            playerView.frame = UIScreen.main.bounds
            playerView.layoutSubviews()
            playerView.delegate = self
            
            playerView.configure(with: track.artworkUrl, trackName: track.trackName)
            
            title = track.artistName
            if let url = URL(string: track.previewUrl), let fileTime = getFileTime(url: url) {
                playerView.setupTimeLabels(totalTime: fileTime)
            }
        }
    }
    
    
    // Gets total time length for song
    
    func getFileTime(url: URL) -> String? {
        var avUrlAsset: AVURLAsset? = AVURLAsset(url: url)
        if let asset = avUrlAsset {
            let audioDuration: CMTime? = asset.duration
            if let audioDuration = audioDuration {
                let audioDurationSeconds: Float64? = CMTimeGetSeconds(audioDuration)
                if let secondsDuration = audioDurationSeconds {
                    let minutes = Int(secondsDuration / 60)
                    let rem = Int(secondsDuration.truncatingRemainder(dividingBy: 60))
                    
                    avUrlAsset = nil
                    return "\(minutes):\(rem)"
                }
            }
        }
        return nil
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let playerView = playerView {
            stopPlayer()
            dump(playerView)
            playerView.removeFromSuperview()
        }
        playerView = nil
        dump(playerView)
        dismiss(animated: true, completion: nil)
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
        player = try AVPlayer(url: nsURL)
        guard let player = player else { return }
        player.rate = 1
        player.play()
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

