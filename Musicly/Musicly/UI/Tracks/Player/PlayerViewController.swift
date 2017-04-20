//
//  PlayerViewController.swift
//  Musicly


import UIKit
import AVFoundation

final class PlayerViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    var player: AVPlayer?
    var playerView: PlayerView = PlayerView()
    var playListItem: PlaylistItem?
    
    var playList: Playlist?
    var track: iTrack?
    var rightButtonItem: UIBarButtonItem?
    var index: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []
        navigationController?.isNavigationBarHidden = false
        view.addSubview(playerView)
        rightButtonItem = UIBarButtonItem.init(
            title: "Title",
            style: .done,
            target: self,
            action: #selector(back)
        )
        guard let rightButtonItem = rightButtonItem else { return }
        navigationItem.rightBarButtonItems = [rightButtonItem]
        playerView.frame = UIScreen.main.bounds
        playerView.layoutSubviews()
        playerView.delegate = self
    }
    
    func setupPlayItem(index: Int) {
        playListItem = self.playList?.playlistItem(at: index)
        self.track = playListItem?.track
        playerView.configure(with: playListItem?.track?.artworkUrl, trackName: playListItem?.track?.trackName)
        title = track?.artistName
        guard let track = track else { return }
        guard let previewUrl = track.previewUrl else { return }
        guard let url = URL(string: previewUrl) else { return }
        guard let fileTime = getFileTime(url: url) else { return }
        playerView.setupTimeLabels(totalTime: fileTime)
    }
    
    func back() {
        presentingViewController?.dismiss(animated: true, completion: nil)
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
        
        stopPlayer()
        dump(playerView)
        playerView.removeFromSuperview()
        
        
        dump(playerView)
        dismiss(animated: true, completion: nil)
    }
    
    func actionClose(_ tap: UITapGestureRecognizer) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    final func initPlayer(url: URL)  {
        if let player = player {
            player.play()
        } else {
            player = AVPlayer(url: url)
            guard let player = player else { return }
            player.play()
        }
    }
}

extension PlayerViewController: PlayerViewDelegate {
    
    func backButtonTapped() {
        guard let previous = playListItem?.previous else { return }
        stopPlayer()
        playListItem = previous
        DispatchQueue.main.async {
            if let track = self.playListItem?.track, let urlString = track.previewUrl, let url = URL(string: urlString) {
                self.initPlayer(url: url)
                self.playerView.configure(with: track.artworkUrl, trackName: track.trackName)
            }
        }
        
    }
    
    func skipButtonTapped() {
        
        playListItem = playListItem?.next
        stopPlayer()
        DispatchQueue.main.async {
            guard let track = self.playListItem?.track, let previewUrl = track.previewUrl, let url = URL(string: previewUrl) else { return }
            self.initPlayer(url: url)
            self.playerView.configure(with: track.artworkUrl, trackName: track.trackName)
        }
    }
    
    
    func pauseButtonTapped() {
        stopPlayer()
        print("pause")
    }
    
    func resetPlayerAndSong() {
        print("reset")
    }
    
    // MARK: - Thumbs
    
    func thumbsDownTapped() {
        dump(playListItem)
        track?.thumbs = .down
        print("thumbs down")
    }
    
    func thumbsUpTapped() {
        dump(track)
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
