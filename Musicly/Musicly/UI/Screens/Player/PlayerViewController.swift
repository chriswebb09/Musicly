//
//  PlayerViewController.swift
//  Musicly


import UIKit
import RealmSwift
import AVFoundation

final class PlayerViewController: UIViewController {
    
    var player: AVPlayer = AVPlayer()
    var playerView: PlayerView = PlayerView()
    var playListItem: PlaylistItem?
    var avUrlAsset: AVURLAsset?
    var playList: Playlist?
    var rightButtonItem: UIBarButtonItem! = UIBarButtonItem.init(image: #imageLiteral(resourceName: "heartorangesmall"), style: .done, target: self, action: #selector(add))
    var index: Int!
    
    let realm = try! Realm()
    
    // Gets data from Realm
    
    var playlistList: Results<TrackList>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        baseControllerSetup()
        baseViewSetup()
        setupItem(index: index)
        playerView.delegate = self
        navigationItem.rightBarButtonItems = [rightButtonItem]
        rightButtonItem.image = #imageLiteral(resourceName: "orange-record-small").withRenderingMode(UIImageRenderingMode.alwaysOriginal)
    }
    
    func baseControllerSetup() {
        edgesForExtendedLayout = []
        navigationController?.isNavigationBarHidden = false
    }
    
    func baseViewSetup() {
        view.addSubview(playerView)
        playerView.frame = UIScreen.main.bounds
        playerView.layoutSubviews()
    }
    
    func setupItem(index: Int) {
        playListItem = playList?.playlistItem(at: index)
        guard let track = playListItem?.track else { return }
        guard let url = URL(string: track.previewUrl) else { return }
        title = track.artistName
        let viewModel = PlayerViewModel(track: track, playState: .queued)
        playerView.configure(with: viewModel)
        initPlayer(url: url)
    }
    
    func add() {
        guard let trackAdded = self.playListItem?.track else { return }
        let tabbar = self.tabBarController as! TabBarController
        let store = tabbar.store
        store.setupItem(with: trackAdded)
    }
    
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
    }
    
}

extension PlayerViewController: PlayerViewDelegate {
    
    // MARK: - Player controlers
    
    func playButtonTapped() {
        player.play()
        playerView.startEqualizer()
        playerView.setTimer()
        player.addPeriodicTimeObserver(forInterval: CMTimeMake(1, 30), queue: .main) { time in
            let fraction = CMTimeGetSeconds(time) / CMTimeGetSeconds(self.player.currentItem!.duration)
            let time = fraction / 450
            self.playerView.updateProgressBar(value: time)
        }
    }
    
    func pauseButtonTapped() {
        playerView.stopEqualizer()
        player.pause()
    }
    
    func backButtonTapped() {
        guard let previous = playListItem?.previous else { return }
        playListItem = previous
        player.pause()
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
        player.pause()
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
