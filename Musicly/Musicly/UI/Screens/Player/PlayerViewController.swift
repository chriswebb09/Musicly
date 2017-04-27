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
    var rightButtonItem: UIBarButtonItem?
    var index: Int?
    
    var currentPlayerID: CurrentListID!
    
    let realm = try! Realm()
    
    // Gets data from Realm
    
    var playlistList: Results<TrackList>!
    
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
        rightButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "heartorangesmall"),
                                               style: .done,
                                               target: self,
                                               action: #selector(add))
        rightButtonItem?.tintColor = UIColor.orange
        guard let rightButtonItem = self.rightButtonItem else { return }
        navigationItem.rightBarButtonItems = [rightButtonItem]
        rightButtonItem.image = #imageLiteral(resourceName: "orange-record-small").withRenderingMode(UIImageRenderingMode.alwaysOriginal)
    }
    
    func setupPlayItem(index: Int?) {
        guard let index = index else { return }
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
    }
    
}

extension PlayerViewController: PlayerViewDelegate {
    
    func backButtonTapped() {
        guard let previous = playListItem?.previous else { return }
        playListItem = previous
        stopPlayer()
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
        stopPlayer()
        DispatchQueue.main.async {
            guard let track = self.playListItem?.track else { return }
            let viewModel = PlayerViewModel(track: track, playState: .queued)
            self.playerView.configure(with: viewModel)
            self.initPlayer(url: URL(string: Track().previewUrl)!)
            self.playerView.updateProgressBar(value: 0)
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
        guard playListItem != nil else { return }
    }
    
    func thumbsUpTapped() {
        guard playListItem != nil else { return }
    }
    
    // MARK: - Player controlers
    
    func stopPlayer() {
        player.pause()
    }
    
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
}

extension PlayerViewController: UIViewControllerTransitioningDelegate {
    // Implement
}
