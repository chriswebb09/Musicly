//
//  PlayerViewController.swift
//  Musicly


import UIKit
import RealmSwift
import AVFoundation

final class PlayerViewController: UIViewController {
    
    var playerView: PlayerView = PlayerView()
    var playListItem: PlaylistItem?
    var menuPop: BottomMenuPopover = BottomMenuPopover()
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
        playListItem = playList?.playlistItem(at: index)
        setupItem(item: playListItem)
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
    
    func moreButtonTapped() {
        menuPop.setupPop()
        UIView.animate(withDuration: 0.15) {
            self.menuPop.showPopView(viewController: self)
            self.menuPop.popView.isHidden = false
        }
    }
    
    fileprivate func setupItem(item: PlaylistItem?) {
        guard let item = item else { return }
        guard let track = item.track else { return }
        guard let url = URL(string: track.previewUrl) else { return }
        title = track.artistName
        DispatchQueue.main.async {
            let viewModel = PlayerViewModel(track: track, playState: .queued)
            self.playerView.configure(with: viewModel)
            print("Done!")
        }
        self.initPlayer(url: url)
    }
    
    private func initPlayer(url: URL)  {
        trackPlayer = TrackPlayer(url: url)
        trackPlayer.delegate = self
        print("before")
        trackPlayer.getTrackDuration { stringValue, floatValue in
            print("Finished")
            DispatchQueue.main.async {
                self.playerView.setupTimeLabels(totalTime: stringValue, timevalue: Float(floatValue))
            }
        }
        
    }
    
    // MARK: - Player controlers
    
    func playButtonTapped() {
        trackPlayer.play()
        playerView.startEqualizer()
        playerView.setTimer()
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
            guard let track = previous.track, let url = URL(string: track.previewUrl) else { return }
            let viewModel = PlayerViewModel(track: track, playState: .queued)
            self.playerView.configure(with: viewModel)
            self.initPlayer(url: url)
            self.playerView.updateProgressBar(value: 0)
            self.title = track.artistName
        }
    }
    
    
    func skipButtonTapped() {
        guard let next = playListItem?.next else { return }
        playListItem = next
        trackPlayer.player.pause()
        DispatchQueue.main.async {
            guard let track = next.track, let url =  URL(string: track.previewUrl) else { return }
            let viewModel = PlayerViewModel(track: track, playState: .queued)
            self.playerView.configure(with: viewModel)
            self.initPlayer(url: url)
            self.playerView.updateProgressBar(value: 0)
            self.title = track.artistName
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

extension PlayerViewController: TrackPlayerDelegate {

    func updateProgress(progress: Double) {
        DispatchQueue.main.async {
            self.playerView.updateProgressBar(value: progress)
        }
    }

    
}

extension PlayerViewController: UIViewControllerTransitioningDelegate {
    // Implement
}
