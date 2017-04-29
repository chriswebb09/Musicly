//
//  PlayerViewController.swift
//  Musicly


import UIKit
import RealmSwift
import AVFoundation

final class PlayerViewController: UIViewController {
    
    var playerView: PlayerView = PlayerView()
    var playListItem: PlaylistItem?
    var playList: Playlist?
    var rightButtonItem: UIBarButtonItem!
    var index: Int!
    var trackPlayer: TrackPlayer!
    let realm = try! Realm()
    
    // Gets data from Realm
    
    var playlistList: Results<TrackList>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBarButton()
        baseControllerSetup()
        baseViewSetup()
        setupItem(index: index)
        playerView.delegate = self
    }
    
    private func setupBarButton() {
        let rightButtonImage = #imageLiteral(resourceName: "orange-record-small").withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        rightButtonItem = UIBarButtonItem.init(image: rightButtonImage, style: .done, target: self, action: #selector(add))
        navigationItem.rightBarButtonItems = [rightButtonItem]
    }
    
    private func baseControllerSetup() {
        edgesForExtendedLayout = []
        navigationController?.isNavigationBarHidden = false
    }
    
    private func baseViewSetup() {
        view.addSubview(playerView)
        playerView.frame = UIScreen.main.bounds
        playerView.layoutSubviews()
    }
    
    func add() {
        guard let trackAdded = self.playListItem?.track else { return }
        let tabbar = tabBarController as! TabBarController
        let store = tabbar.store
        store?.setupItem(with: trackAdded)
    }
    
    private final func getFileTime(url: URL) -> String? {
        guard let previewUrl = playListItem?.track?.previewUrl else { return nil }
        trackPlayer = TrackPlayer(url: URL(string: previewUrl)!)
        let audioDuration: CMTime = trackPlayer.asset.duration
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
        playerView.removeFromSuperview()
        trackPlayer.player.pause()
        dismiss(animated: true, completion: nil)
    }
    
    func actionClose(_ tap: UITapGestureRecognizer) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
}

extension PlayerViewController: PlayerViewDelegate {
    
    fileprivate func setupItem(index: Int) {
        playListItem = playList?.playlistItem(at: index)
        guard let track = playListItem?.track else { return }
        guard let url = URL(string: track.previewUrl) else { return }
        title = track.artistName
        let viewModel = PlayerViewModel(track: track, playState: .queued)
        playerView.configure(with: viewModel)
        initPlayer(url: url)
    }
    
    private func initPlayer(url: URL)  {
        trackPlayer = TrackPlayer(url: url)
        trackPlayer.asset.loadValuesAsynchronously(forKeys: ["tracks", "duration"]) {
            let audioDuration: CMTime = self.trackPlayer.asset.duration
            let audioDurationSeconds: Float64? = CMTimeGetSeconds(audioDuration)
            if let secondsDuration = audioDurationSeconds {
                let minutes = Int(secondsDuration / 60)
                let rem = Int(secondsDuration.truncatingRemainder(dividingBy: 60))
                DispatchQueue.main.async {
                    self.playerView.setupTimeLabels(totalTime: "\(minutes):\(rem + 2)", timevalue: Float(secondsDuration))
                }
            }
        }
    }
    
    // MARK: - Player controlers
    
    func playButtonTapped() {
        trackPlayer.player.play()
        playerView.startEqualizer()
        playerView.setTimer()
        trackPlayer.player.addPeriodicTimeObserver(forInterval: CMTimeMake(1, 30), queue: .main) { time in
            guard let currentItem = self.trackPlayer.player.currentItem else { return }
            let fraction = CMTimeGetSeconds(time) / CMTimeGetSeconds(currentItem.duration)
            let time = fraction / 450
            self.playerView.updateProgressBar(value: time)
        }
    }
    
    func pauseButtonTapped() {
        playerView.stopEqualizer()
        trackPlayer.player.pause()
    }
    
    func backButtonTapped() {
        guard let previous = playListItem?.previous else { return }
        playListItem = previous
        trackPlayer.player.pause()
        DispatchQueue.main.async { [unowned self] in
            if let track = self.playListItem?.track,
                let url = URL(string: track.previewUrl) {
                self.title = track.artistName
                let viewModel = PlayerViewModel(track: track, playState: .queued)
                self.playerView.configure(with: viewModel)
                self.initPlayer(url: url)
                self.playerView.updateProgressBar(value: 0)
            }
        }
    }
    
    func skipButtonTapped() {
        playListItem = playListItem?.next
        trackPlayer.player.pause()
        DispatchQueue.main.async {
            guard let track = self.playListItem?.track else { return }
            let viewModel = PlayerViewModel(track: track, playState: .queued)
            self.playerView.configure(with: viewModel)
            guard let url =  URL(string: track.previewUrl) else { return }
            self.initPlayer(url: url)
            self.playerView.updateProgressBar(value: 0)
        }
    }
    
    func resetPlayerAndSong() {
        print("reset")
    }
    
    // MARK: - Thumbs
    
    func thumbsDownTapped() {
        if let playlistItem = playListItem, let track = playlistItem.track {
            track.thumbs?.thumb = .down
        }
    }
    
    func thumbsUpTapped() {
        if let playlistItem = playListItem, let track = playlistItem.track {
            track.thumbs?.thumb = .up
        }
    }
}

extension PlayerViewController: UIViewControllerTransitioningDelegate {
    // Implement
}
