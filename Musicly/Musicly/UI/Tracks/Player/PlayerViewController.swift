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
            guard let url = URL(string: track.previewUrl) else { return }
            guard let fileTime = getFileTime(url: url) else { return }
            playerView.setupTimeLabels(totalTime: fileTime)
        }
    }
    
    
    // Gets total time length for song
    
    private final func getFileTime(url: URL) -> String? {
        var avUrlAsset: AVURLAsset? = AVURLAsset(url: url)
        if let asset = avUrlAsset {
            let audioDuration: CMTime = asset.duration
            let audioDurationSeconds: Float64? = CMTimeGetSeconds(audioDuration)
            if let secondsDuration = audioDurationSeconds {
                let minutes = Int(secondsDuration / 60)
                let rem = Int(secondsDuration.truncatingRemainder(dividingBy: 60))
                avUrlAsset = nil
                return "\(minutes):\(rem)"
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
    
    final func initPlayer(url: URL)  {
        if let player = player {
            print("playing")
            player.play()
        } else {
            player = AVPlayer(url: url)
            guard let player = player else { return }
            player.play()
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
        player = nil
    }
    
    func playButtonTapped() {
        guard let urlString = track?.previewUrl else { return }
        guard let url = URL(string: urlString) else { return }
        initPlayer(url: url)
    }
}

