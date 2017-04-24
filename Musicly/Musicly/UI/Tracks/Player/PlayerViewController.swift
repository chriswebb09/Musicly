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
    var playlistList: Results<TrackList>!
    var currentID: Results<CurrentListID>!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currentID = realm.objects(CurrentListID.self)
        let test = currentID.first
        currentPlayerID = test
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
                                               action: #selector(add)
        )
        
        rightButtonItem?.tintColor = UIColor.orange
        
        guard let rightButtonItem = self.rightButtonItem else { return }
        navigationItem.rightBarButtonItems = [rightButtonItem]
        rightButtonItem.tintColor = .orange
        rightButtonItem.image = #imageLiteral(resourceName: "heartorangesmall").withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.navigationItem.rightBarButtonItem?.tintColor = .orange
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
    
    func setupItem(with track: Track) -> Track {
        let item = Track()
        if let currentPlatID = currentPlayerID {
            item.playlistID = currentPlayerID.id
        }
        item.artistID = track.artistID
        item.artworkUrl = track.artworkUrl
        item.artistName = track.artistName
        return item
    }
    
    func add() {
         var new = setupItem(with: (self.playListItem?.track)!)
        let tabbar = self.tabBarController as! TabBarController
        let store = tabbar.store
        store.saveTrack(track: new)
       // store.saveItem(playlistItem: playListItem!)
        //store.lists.last?.appendToTracks(track: new)
       // guard let list = store.lists.last else { return }
       // list.appendToTracks(track: new)
       // store.save(list: list)
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
        print(player.isPlaying)
    }
    
    func save(entityList: [TrackList], shouldUpdate update: Bool = true) {
        var database = try! Realm()
        
        database.beginWrite()
        for entity in entityList {
            if let key = type(of: entity).primaryKey(), let value = entity[key] , update {
                if let existingObject = database.object(ofType: type(of: entity), forPrimaryKey: value as AnyObject) {
                    let relationships = existingObject.objectSchema.properties.filter {
                        $0.type == .array
                    }
                    for relationship in relationships {
                        if let newObjectRelationship = entity[relationship.name] as? ListBase , newObjectRelationship.count == 0 {
                            entity[relationship.name] = existingObject[relationship.name]
                        }
                    }
                }
            }
            database.add(entity, update: update)
        }
        
        do {
            try database.commitWrite()
        } catch let writeError {
            debugPrint("Unable to commit write: \(writeError)")
        }
        
        database.refresh()
        //.appendToTracks(track: new)
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

extension PlayerViewController: UIViewControllerTransitioningDelegate {
    // Implement
}
