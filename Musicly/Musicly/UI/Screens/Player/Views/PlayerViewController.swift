//
//  PlayerViewController.swift
//  Musicly

import UIKit

//protocol Playable {
//    func play()
//    
//}

final class PlayerViewController: UIViewController {
    
    var model: PlayerControllerModel?
    
    var playerView = PlayerView()
    var menuPop = BottomMenuPopover()
    var loadingPop = LoadingPopover()
    
    var rightButtonItem: UIBarButtonItem!
    
    var trackPlayer: Playable
    
    init(playable: Playable) {
        self.trackPlayer = playable
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let model = model else { return }
        if !model.parentIsPlaylist { setupBarButton() }
        baseControllerSetup()
        loadingPop.showPopView(viewController: self)
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
        baseViewSetup(playerView: playerView, view: view)
    }
    
    private func baseViewSetup(playerView: PlayerView, view: UIView) {
        view.addSubview(playerView)
        playerView.frame = UIScreen.main.bounds
        playerView.layoutSubviews()
    }
    
    func add() {
        guard let model = model, let trackAdded = model.playListItem?.track else { return }
        let tabbar = tabBarController as! TabBarController
        let store = tabbar.store
        guard let currentID = store?.currentPlaylistID else { return }
        guard let client = store?.realmClient else { return }
        store?.setupItem(with: trackAdded, currentPlaylistID: currentID, realmClient: client)
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
            strongSelf.playerView.configureWith(viewModel)
        }
        initPlayer(url: url)
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
    
    func changeTrack(track: Track) {
        trackPlayer.player.pause()
        loadingPop.showPopView(viewController: self)
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self, let url = URL(string: track.previewUrl) else { return }
            let viewModel = PlayerViewModel(track: track, playState: .queued)
            strongSelf.playerView.configureWith(viewModel)
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
        playerView.model?.playState = .queued
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
            guard let model = self?.playerView.model else { return }
            strongSelf.playerView.setupTimeLabels(totalTime: stringTime, timevalue: Float(timeValue))
            strongSelf.playerView.playbuttonEnabled(is: true)
            strongSelf.loadingPop.hidePopView(viewController: strongSelf)
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
