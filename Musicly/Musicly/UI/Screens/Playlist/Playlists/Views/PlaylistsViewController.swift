import UIKit
import RealmSwift

final class PlaylistsViewController: UIViewController {
    
    let detailPop = NewPlaylistPopover()
    var dataSource = PlaylistsViewControllerDataSource()
    lazy var collectionView : UICollectionView = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: UICollectionViewFlowLayout())
    var rightBarButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        title = "Playlists"
        setupPlaylistCollectionView(layout: UICollectionViewFlowLayout())
        detailPop.delegate = self
        rightBarButtonItem = UIBarButtonItem.init(image: dataSource.buttonImage, style: .done, target: self, action: #selector(pop))
        collectionViewSetup(with: collectionView)
        detailPop.popView.playlistNameField.delegate = self
        guard let rightButtonItem = rightBarButtonItem else { return }
        navigationItem.rightBarButtonItems = [rightButtonItem]
    }
    
    func collectionViewSetup(with collectionView: UICollectionView) {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PlaylistCell.self, forCellWithReuseIdentifier: PlaylistCell.identifier)
        collectionView.backgroundColor = PlaylistViewControllerConstants.backgroundColor
        view.addSubview(collectionView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

extension PlaylistsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let tracklists = dataSource.store.trackLists {
            dataSource.tracklist = Array(tracklists)
        }
        return dataSource.tracklist.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaylistCell.identifier, for: indexPath) as! PlaylistCell
        let index = indexPath.row
        let track = dataSource.tracklist[index]
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
        let dataSource =  setupDestinationDataSource(indexPath: indexPath)
        let destinationVC = setupDestinationVC(dataSource: dataSource)
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(destinationVC, animated: false)
        }
       
    }
    
    func setupDestinationVC(dataSource: TracksPlaylistDataSource) -> PlaylistViewController {
        let destinationVC = PlaylistViewController()
        destinationVC.dataSource = dataSource
        destinationVC.title = dataSource.title
        return destinationVC
    }
    
    func setupDestinationDataSource(indexPath: IndexPath) -> TracksPlaylistDataSource {
        let dataSource = TracksPlaylistDataSource()
        dataSource.store = self.dataSource.store
        dataSource.tracklist = self.dataSource.tracklist[indexPath.row]
        dataSource.store.currentPlaylistID = self.dataSource.tracklist[indexPath.row].listId
        return dataSource
    }
}

extension PlaylistsViewController: PlaylistCreatorDelegate {
    
    func userDidEnterPlaylistName(name: String) {
        dataSource.store.createNewList(newList: TrackList(), name: name, date: Date(), uid: UUID().uuidString)
        if let tracklists = dataSource.store.trackLists, let last = tracklists.last {
            self.dataSource.tracklist.append(last)
        }
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.dataSource.tracklist = strongSelf.dataSource.store.lists
            strongSelf.collectionView.reloadData()
        }
    }
}

extension PlaylistsViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func setupPlaylistCollectionView(layout: UICollectionViewFlowLayout) {
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)
        layout.itemSize = PlaylistViewControllerConstants.itemSize
        collectionView = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: layout)
    }
}
