//
//  PlayerViewController.swift
//  Musicly


import UIKit
import AVFoundation

final class PlayerViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    var player: AVPlayer?
    var playerView: PlayerView? = PlayerView()
    var playListItem: PlaylistItem?
    var playList: Playlist?
    var track: iTrack?
    var rightButtonItem: UIBarButtonItem?
    weak var delegate: PlayerViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []
        
        let navController = self.parent as! UINavigationController
        let parentControllerIndex = navController.viewControllers.count
        let parentController = navController.viewControllers[parentControllerIndex - 2] as! TracksViewController
        parentController.delegate = self
        
        navigationController?.isNavigationBarHidden = false
        rightButtonItem = UIBarButtonItem.init(
            title: "Title",
            style: .done,
            target: self,
            action: #selector(back)
        )
        guard let rightButtonItem = rightButtonItem else { return }
        navigationItem.rightBarButtonItems = [rightButtonItem]
        
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
    
    func setupPlayItem(item: PlaylistItem) {
        self.playListItem = item
        dump(playListItem)
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
        if let playerView = playerView {
            stopPlayer()
            dump(playerView)
            playerView.removeFromSuperview()
        }
        playerView = nil
        dump(playerView)
        dismiss(animated: true, completion: nil)
    }
    
    func actionClose(_ tap: UITapGestureRecognizer) {
        presentingViewController?.dismiss(animated: true, completion: nil)
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
    
    func backButtonTapped() {
        delegate?.setPreviousTrack(newTrack: true)
        delegate?.setPreviousTrack(newTrack: true)
        
        stopPlayer()
        
        DispatchQueue.main.async {
            
            guard let track = self.track, let url = URL(string: track.previewUrl) else { return }
            print("back")
            self.initPlayer(url: url)
            self.playerView?.configure(with: track.artworkUrl, trackName: track.trackName)
        }
        
    }
    
    func skipButtonTapped() {
        delegate?.setNextPlaylistItem(newItem: true)
        delegate?.setNextTrack(newTrack: true)
        stopPlayer()
        DispatchQueue.main.async {
            guard let track = self.track, let url = URL(string: track.previewUrl) else { return }
            print("next")
            self.initPlayer(url: url)
            self.playerView?.configure(with: track.artworkUrl, trackName: track.trackName)
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

extension PlayerViewController: TracksViewControllerDelegate {
    func getPreviousPlaylistItem(item: PlaylistItem) {
        self.playListItem = item
    }
    
    func getNextPlaylistItem(item: PlaylistItem) {
        self.playListItem = item
    }
    
    
    func getNextTrack(iTrack: iTrack) {
        print("get next \(String(describing: playListItem?.track))")
        track = playListItem?.track
    }
    
    func getPrivousTrack(iTrack: iTrack) {
        print("get previous \(String(describing: playListItem?.track))")
        track = playListItem?.track
    }
}
