import UIKit
import RealmSwift

private let reuseIdentifier: String = "PlaylistCell"

final class PlaylistsViewController: UIViewController {
    
    let detailPop = NewPlaylistPopover()
    
    lazy var collectionView : UICollectionView = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: UICollectionViewFlowLayout())
    
    var tabController: TabBarController!
    var store: iTrackDataStore!
    var rightBarButtonItem: UIBarButtonItem!
    
    let buttonImage = #imageLiteral(resourceName: "blue-musicnote").withRenderingMode(UIImageRenderingMode.alwaysOriginal)
    
    var trackList: [TrackList] = []
    var dataSource: ListControllerDataSource!
    
    override func viewDidLoad() {
        title = "Playlists"
        setupPlaylistCollectionView()
        detailPop.delegate = self
        rightBarButtonItem = UIBarButtonItem.init(image: buttonImage, style: .done, target: self, action: #selector(pop))
        tabController = tabBarController as! TabBarController
        collectionViewSetup(with: collectionView)
        detailPop.popView.playlistNameField.delegate = self
        guard let rightButtonItem = rightBarButtonItem else { return }
        navigationItem.rightBarButtonItems = [rightButtonItem]
    }
    
    func collectionViewSetup(with collectionView: UICollectionView) {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PlaylistCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = PlaylistViewControllerConstants.backgroundColor
        view.addSubview(collectionView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        store = tabController.store
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

extension PlaylistsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let tracklists = store.trackLists {
            trackList = Array(tracklists)
        }
        return trackList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PlaylistCell
        let index = indexPath.row
        let track = trackList[index]
        let name = track.listName
        if track.tracks.count > 0 {
            if let arturl = URL(string: track.tracks[0].artworkUrl) {
                cell.configure(playlistName: name, artUrl: arturl, numberOfTracks: String(describing: track.tracks.count))
            }
        } else {
            cell.configure(playlistName: name, artUrl: nil, numberOfTracks: String(describing: track.tracks.count))
        }
        return cell
    }
    
    func pop() {
        UIView.animate(withDuration: 0.15) { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.detailPop.showPopView(viewController: strongSelf)
            strongSelf.detailPop.popView.isHidden = false
        }
        detailPop.popView.doneButton.addTarget(self, action: #selector(hidePop), for: .touchUpInside)
    }
    
    func hidePop() {
        detailPop.hidePopView(viewController: self)
        collectionView.reloadData()
    }
}

extension PlaylistsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destinationVC = PlaylistViewController()
        store.currentPlaylistID = trackList[indexPath.row].listId
        let model = ListControllerDataSource()
        model.store = store
        model.tracklist = store.setupCurrentPlaylist(currentPlaylistID: trackList[indexPath.row].listId, realmClient: store.realmClient)!
        destinationVC.title = trackList[indexPath.row].listName
        destinationVC.dataSource = model
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(destinationVC, animated: false)
        }
    }
}

extension PlaylistsViewController: PlaylistCreatorDelegate {
    
    func userDidEnterPlaylistName(name: String) {
        var tracklist = TrackList()
        tracklist.listName = name
        tracklist.listId = UUID().uuidString
        tracklist.date = String(describing: Date())
        store.createNewList(newList: tracklist, realmClient: store.realmClient)
        if let tracklists = store.trackLists, let last = tracklists.last {
            trackList.append(last)
        }
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.trackList = strongSelf.store.lists
            strongSelf.collectionView.reloadData()
        }
    }
}

extension PlaylistsViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func setupPlaylistCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)
        layout.itemSize = PlaylistViewControllerConstants.itemSize
        collectionView = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: layout)
    }
}
