//
//  PlayerViewController.swift
//  Musicly

import UIKit

class PlayerControllerModel {
    var index: Int
    var playlist: Playlist!
    var parentIsPlaylist: Bool = false
    var menuActive: MenuActive = .none
    var playListItem: PlaylistItem?
    
    init(index: Int) {
        self.index = index
    }
}

final class PlayerViewController: UIViewController {
    
    var model: PlayerControllerModel?
    
    var playerView = PlayerView()
    var menuPop = BottomMenuPopover()
    var loadingPop = LoadingPopover()
    
    var rightButtonItem: UIBarButtonItem!
    lazy var trackPlayer = TrackPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let model = model else { return }
        if !model.parentIsPlaylist { setupBarButton() }
        baseControllerSetup()
        showLoadingView(loadingPop: loadingPop)
        model.playListItem = model.playlist.playlistItem(at: model.index)
        setupItem(item: model.playListItem)
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
        baseViewSetup(playerView: playerView)
    }
    
    private func baseViewSetup(playerView: PlayerView) {
        view.addSubview(playerView)
        playerView.frame = UIScreen.main.bounds
        playerView.layoutSubviews()
    }
    
    func add() {
        guard let model = model, let trackAdded = model.playListItem?.track else { return }
        let tabbar = tabBarController as! TabBarController
        let store = tabbar.store
        guard let currentID = store?.currentPlaylistID else { return }
        store?.setupItem(with: trackAdded, currentPlaylistID: currentID)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        playerView.removeFromSuperview()
        trackPlayer.player.pause()
        dismiss(animated: true, completion: nil)
    }
    
    override func downloadProgressUpdated(for progress: Float) {
        print(progress)
    }
}

extension PlayerViewController: MenuDelegate {
    
    func optionOneTapped() {
        let client = iTunesAPIClient()
        guard let model = model, let track = model.playListItem?.track else { return }
        let download = Download(url: track.previewUrl)
        download.delegate = self
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
        guard let model = model else { return }
        switch model.menuActive {
        case .none:
            showMenu()
            model.menuActive = .active
        case .active:
            dismissMenu()
            model.menuActive = .hidden
        case .hidden:
            showMenu()
            model.menuActive = .active
        }
    }
    
    func showMenu() {
        menuPop.popView.delegate = self
        menuPop.setupPop()
        playerView.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.15) { [weak self] in
            guard let strongSelf = self else { return }
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
        guard let item = item, let track = item.track, let url = URL(string: track.previewUrl) else { return }
        title = track.artistName
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            let viewModel = PlayerViewModel(track: track, playState: .queued)
            strongSelf.playerView.configure(with: viewModel)
        }
        initPlayer(url: url)
    }
    
    func showLoadingView(loadingPop: LoadingPopover) {
        loadingPop.setupPop(popView: loadingPop.popView)
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
        trackPlayer.play(player: trackPlayer.player)
        print(trackPlayer.currentTime)
    }
    
    func pauseButtonTapped() {
        trackPlayer.player.pause()
    }
    
    func changeTrack(track: Track) {
        trackPlayer.player.pause()
        showLoadingView(loadingPop: loadingPop)
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self, let url = URL(string: track.previewUrl) else { return }
            let viewModel = PlayerViewModel(track: track, playState: .queued)
            strongSelf.playerView.configure(with: viewModel)
            strongSelf.initPlayer(url: url)
            strongSelf.playerView.updateProgressBar(value: 0)
            strongSelf.title = track.artistName
        }
    }
    
    func backButtonTapped() {
        guard let model = model, let previous = model.playListItem?.previous, let track = previous.track else { return }
        model.playListItem = previous
        changeTrack(track: track)
    }
    
    func skipButtonTapped() {
        guard let model = model, let next = model.playListItem?.next, let track = next.track else { return }
        model.playListItem = next
        changeTrack(track: track)
    }
    
    func resetPlayerAndSong() {
        playerView.viewModel.playState = .queued
    }
    
    // MARK: - Thumbs
    
    func thumbsDownTapped() {
        if let model = model, let playlistItem = model.playListItem, let track = playlistItem.track {
            track.thumbs?.thumb = .down
        }
    }
    
    func thumbsUpTapped() {
        if let model = model, let playlistItem = model.playListItem, let track = playlistItem.track {
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
            guard let strongSelf = self else { return }
            strongSelf.loadingPop.popView.stopAnimating(ball: strongSelf.loadingPop.popView.ball!)
            strongSelf.playerView.setupTimeLabels(totalTime: stringTime, timevalue: Float(timeValue))
            strongSelf.playerView.playbuttonEnabled(is: true)
            strongSelf.hideLoadingView()
        }
    }
    
    func updateProgress(progress: Double) {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.playerView.updateProgressBar(value: progress)
        }
    }
}

extension PlayerViewController: UIViewControllerTransitioningDelegate {
    // Implement
}
