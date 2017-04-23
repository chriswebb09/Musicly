//
//  PlayerViewController.swift
//  Musicly


import UIKit
import AVFoundation

final class PlayerViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    var player: AVPlayer = AVPlayer()
    var playerView: PlayerView = PlayerView()
    var playListItem: PlaylistItem?
    var avUrlAsset: AVURLAsset?
    var playList: Playlist?
    var rightButtonItem: UIBarButtonItem?
    var index: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playList?.printAllKeys()
        edgesForExtendedLayout = []
        navigationController?.isNavigationBarHidden = false
        view.addSubview(playerView)
        playerView.frame = UIScreen.main.bounds
        playerView.layoutSubviews()
        setupPlayItem(index: index)
        playerView.delegate = self
    }
    
    func setupPlayItem(index: Int?) {
        guard let index = index else { return }
        playListItem = playList?.playlistItem(at: index)
        guard let track = playListItem?.track else { return }
        guard let previewUrl = track.previewUrl else { return }
        guard let url = URL(string: previewUrl) else { return }
        guard let name = track.artistName else { return }
        title = name
        playerView.configure(with: playListItem?.track?.artworkUrl, trackName: playListItem?.track?.trackName, thumbs: .none)
        initPlayer(url: url)
    }
    
    func back() {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    // Gets total time length for song
    
    private final func getFileTime(url: URL) -> String? {
        avUrlAsset = AVURLAsset(url: url)
        guard let avUrlAsset = avUrlAsset else { return nil }
        let audioDuration: CMTime = avUrlAsset.duration
        let audioDurationSeconds: Float64? = CMTimeGetSeconds(audioDuration)
        if let secondsDuration = audioDurationSeconds {
            let minutes = Int(secondsDuration / 60)
            let rem = Int(secondsDuration.truncatingRemainder(dividingBy: 60))
            return "\(minutes):\(rem + 3)"
        }
        return nil
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopPlayer()
        playerView.removeFromSuperview()
        dismiss(animated: true, completion: nil)
    }
    
    func actionClose(_ tap: UITapGestureRecognizer) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    final func initPlayer(url: URL)  {
        avUrlAsset = AVURLAsset(url: url)
        guard let asset = avUrlAsset else { return }
        let item = AVPlayerItem(asset: asset)
        let audioDuration: CMTime = asset.duration
        let audioDurationSeconds: Float64? = CMTimeGetSeconds(audioDuration)
        if let secondsDuration = audioDurationSeconds {
            let minutes = Int(secondsDuration / 60)
            let rem = Int(secondsDuration.truncatingRemainder(dividingBy: 60))
            self.playerView.setupTimeLabels(totalTime: "\(minutes):\(rem + 2)")
        }
        player = AVPlayer(playerItem: item)
        print(player.isPlaying)
    }
}

extension PlayerViewController: PlayerViewDelegate {
    
    func backButtonTapped() {
        guard let previous = playListItem?.previous else { return }
        playListItem = previous
        stopPlayer()
        DispatchQueue.main.async { [unowned self] in
            if let track = self.playListItem?.track, let urlString = track.previewUrl, let url = URL(string: urlString) {
                self.title = track.artistName
                self.initPlayer(url: url)
                guard let thumb = self.playListItem?.track?.thumbs else { return }
                self.playerView.configure(with: track.artworkUrl, trackName: track.trackName, thumbs: thumb)
            }
        }
    }
    
    func skipButtonTapped() {
        playListItem = playListItem?.next
        stopPlayer()
        DispatchQueue.main.async {
            guard let track = self.playListItem?.track, let previewUrl = track.previewUrl, let url = URL(string: previewUrl) else { return }
            self.title = track.artistName
            self.initPlayer(url: url)
            guard let thumb = self.playListItem?.track?.thumbs else { return }
            self.playerView.configure(with: track.artworkUrl, trackName: track.trackName, thumbs: thumb)
        }
    }
    
    
    func pauseButtonTapped() {
        playerView.stopEqualizer()
        player.pause()
    }
    
    func resetPlayerAndSong() {
        print("reset")
    }
    
    // MARK: - Thumbs
    
    func thumbsDownTapped() {
        guard let item = playListItem else { return }
        item.track?.thumbs = .down
    }
    
    func thumbsUpTapped() {
        guard let item = playListItem else { return }
        item.track?.thumbs = .up
    }
    
    // MARK: - Player controlers
    
    func stopPlayer() {
        player.pause()
    }
    
    func playButtonTapped() {
        DispatchQueue.main.async {
            self.player.play()
            self.playerView.startEqualizer()
            self.playerView.setTimer()
            self.player.addPeriodicTimeObserver(forInterval: CMTimeMake(1, 30), queue: .main) { time in
                let fraction = CMTimeGetSeconds(time) / CMTimeGetSeconds(self.player.currentItem!.duration)
                let time = fraction / 450
                self.playerView.updateProgressBar(value: time)
            }
        }
    }
}
