//
//  PlayerViewController.swift
//  Musicly


import UIKit
import RealmSwift
import AVFoundation

final class PlayerViewController: UIViewController {
    
    var playerView = PlayerView()
    var playListItem: PlaylistItem?
    var menuPop = BottomMenuPopover()
    var loadingPop = LoadingPopover()
    var playList: Playlist?
    var rightButtonItem: UIBarButtonItem!
    var index: Int!
    lazy var trackPlayer = TrackPlayer()
    let realm = try! Realm()
    var menuActive: MenuActive = .none
    
    // Gets data from Realm
    
    var playlistList: Results<TrackList>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBarButton()
        baseControllerSetup()
        baseViewSetup()
        showLoadingView()
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
        guard let trackAdded = playListItem?.track else { return }
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

extension PlayerViewController: DownloadDelegate {
    func downloadProgressUpdated(for progress: Float) {
        print(progress)
    }
}

extension PlayerViewController: MenuDelegate {
    
    func optionOneTapped() {
        guard let track = playListItem?.track else { return }
        let download = Download(url: track.previewUrl)
        download.delegate = self
        let client = iTunesAPIClient()
        client.downloadTrackPreview(for: download)
    }
    
    func optionTwoTapped() {
        print("Option two tapped")
    }
    
    func optionThreeTapped() {
        print("option three")
    }
}

extension PlayerViewController: PlayerViewDelegate {
    
    func moreButtonTapped() {
        switch menuActive {
        case .none:
            showMenu()
            menuActive = .active
        case .active:
            dismissMenu()
            menuActive = .hidden
        case .hidden:
            showMenu()
            menuActive = .active
        }
    }
    
    func showMenu() {
        menuPop.popView.delegate = self
        menuPop.setupPop()
        playerView.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.15) { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.menuPop.showPopView(viewController: strongSelf)
            strongSelf.menuPop.popView.isHidden = false
        }
    }
    
    func dismissMenu() {
        menuPop.popView.removeFromSuperview()
        menuPop.hidePopView(viewController: self)
        view.sendSubview(toBack: menuPop)
    }
    
    fileprivate func setupItem(item: PlaylistItem?) {
        guard let item = item else { return }
        guard let track = item.track else { return }
        guard let url = URL(string: track.previewUrl) else { return }
        title = track.artistName
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {
                return
            }
            let viewModel = PlayerViewModel(track: track, playState: .queued)
            strongSelf.playerView.configure(with: viewModel)
        }
        initPlayer(url: url)
    }
    
    func showLoadingView() {
        loadingPop.setupPop()
        loadingPop.showPopView(viewController: self)
        loadingPop.popView.isHidden = false
    }
    
    func hideLoadingView() {
        loadingPop.popView.removeFromSuperview()
        loadingPop.removeFromSuperview()
        loadingPop.hidePopView(viewController: self)
        view.sendSubview(toBack: loadingPop)
    }
    
    private func initPlayer(url: URL)  {
        trackPlayer = TrackPlayer(url: url)
        trackPlayer.delegate = self
    }
    
    // MARK: - Player controlers
    
    func playButtonTapped() {
        trackPlayer.play()
        print(trackPlayer.currentTime)
    }
    
    func pauseButtonTapped() {
        trackPlayer.player.pause()
    }
    
    func backButtonTapped() {
        guard let previous = playListItem?.previous else { return }
        playListItem = previous
        trackPlayer.player.pause()
        showLoadingView()
        loadingPop.popView.startAnimating()
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {
                return
            }
            guard let track = previous.track, let url = URL(string: track.previewUrl) else { return }
            let viewModel = PlayerViewModel(track: track, playState: .queued)
            strongSelf.playerView.configure(with: viewModel)
            strongSelf.initPlayer(url: url)
            strongSelf.playerView.updateProgressBar(value: 0)
            strongSelf.title = track.artistName
        }
    }
    
    
    func skipButtonTapped() {
        guard let next = playListItem?.next else { return }
        playListItem = next
        trackPlayer.player.pause()
        showLoadingView()
        loadingPop.popView.startAnimating()
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {
                return
            }
            guard let track = next.track, let url =  URL(string: track.previewUrl) else { return }
            let viewModel = PlayerViewModel(track: track, playState: .queued)
            strongSelf.playerView.configure(with: viewModel)
            strongSelf.initPlayer(url: url)
            strongSelf.playerView.updateProgressBar(value: 0)
            strongSelf.title = track.artistName
        }
    }
    
    
    func resetPlayerAndSong() {
        playerView.viewModel.playState = .queued
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
    
    func trackFinishedPlaying() {
        print("DONE")
    }
    
    func trackDurationCalculated(stringTime: String, timeValue: Float64) {
        print(stringTime)
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.loadingPop.popView.stopAnimating()
            strongSelf.playerView.setupTimeLabels(totalTime: stringTime, timevalue: Float(timeValue))
            strongSelf.playerView.playbuttonEnabled(is: true)
            strongSelf.hideLoadingView()
        }
    }
    
    func updateProgress(progress: Double) {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.playerView.updateProgressBar(value: progress)
        }
    }
}

extension PlayerViewController: UIViewControllerTransitioningDelegate {
    // Implement
}