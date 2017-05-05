//
//  PlaylistViewController.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 4/26/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit
import RealmSwift

private let reuseIdentifier = "trackCell"


final class PlaylistViewController: UIViewController {
    
    var playlist: Playlist = Playlist() {
        didSet {
            if playlist.itemCount > 0 {
                contentState = .results
            } else {
                contentState = .none
            }
        }
    }
    var store: iTrackDataStore?
    var emptyView = EmptyView() {
        didSet {
            emptyView.configure()
        }
    }
    
    var tracklist: TrackList = TrackList() {
        didSet {
            for track in tracklist.tracks {
                let newItem = PlaylistItem()
                newItem.track = track
                if !playlist.contains(playlistItem: newItem) {
                    playlist.append(newPlaylistItem: newItem)
                }
            }
        }
    }
    
    var contentState: TrackContentState = .none {
        didSet {
            switch contentState {
            case .none:
                self.view.bringSubview(toFront: emptyView)
                print("None")
            case .results:
                self.view.bringSubview(toFront: collectionView!)
            case.loaded:
                self.view.bringSubview(toFront: collectionView!)
            case .loading:
                return
            }
        }
    }
    
    fileprivate var image = #imageLiteral(resourceName: "search-button").withRenderingMode(.alwaysOriginal)
    var buttonItem: UIBarButtonItem?
    
    var collectionView : UICollectionView? = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.addSubview(emptyView)
        emptyView.frame = view.frame
        emptyView.configure()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        title = tracklist.listName
        commonInit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.rightBarButtonItems = [buttonItem!]
    }
    
    private func commonInit() {
        buttonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(goToSearch))
        edgesForExtendedLayout = []
        setupCollectionView()
        navigationItem.setRightBarButton(buttonItem, animated: false)
        setupDefaultUI()
        collectionView?.backgroundColor = CollectionViewConstants.backgroundColor
        collectionViewRegister()
    }
    
    func goToSearch() {
        tabBarController?.selectedIndex = 0
        let navController = tabBarController?.viewControllers?[0] as! UINavigationController
        let controller = navController.viewControllers[0] as! TracksViewController
        controller.navigationBarSetup()
        navigationController?.popViewController(animated: false)
    }
    
    private func collectionViewRegister() {
        collectionView?.register(TrackCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView?.dataSource = self
        collectionView?.delegate = self
    }
    
    private func setupCollectionView() {
        let newLayout = PlaylistItemLayout()
        newLayout.setup()
        collectionView?.collectionViewLayout = newLayout
        collectionView?.frame = UIScreen.main.bounds
        view.backgroundColor = CollectionViewAttributes.backgroundColor
        if let collectionView = collectionView { view.addSubview(collectionView) }
    }
}

// MARK: - UICollectionViewDataSource
extension PlaylistViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(playlist.itemCount)
        return playlist.itemCount
    }
    
    fileprivate func setTrackCell(indexPath: IndexPath?, cell: TrackCell) {
        var rowTime: Double
        if let index = indexPath, let track = playlist.playlistItem(at: index.row)?.track {
            if index.row > 10 {
                rowTime = (Double(index.row % 10)) / CollectionViewConstants.rowTimeDivider
            } else {
                rowTime = (Double(index.row)) / CollectionViewConstants.rowTimeDivider
            }
            if let url = URL(string: track.artworkUrl) {
                let viewModel = TrackCellViewModel(trackName: track.trackName, albumImageUrl: url)
                cell.configureCell(with: viewModel, withTime: rowTime)
            }
        }
    }
}

extension PlaylistViewController {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destinationViewController: PlayerViewController = PlayerViewController()
        destinationViewController.playList = playlist
        destinationViewController.hidesBottomBarWhenPushed = true
        destinationViewController.index = indexPath.row
        navigationController?.pushViewController(destinationViewController, animated: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TrackCell
        if let track = playlist.playlistItem(at: indexPath.row)?.track, let url = URL(string: track.artworkUrl) {
            let cellViewModel = TrackCellViewModel(trackName: track.trackName, albumImageUrl: url)
            cell.configureCell(with: cellViewModel, withTime: 0)
        }
        let finalFrame = cell.frame
        let translation: CGPoint = collectionView.panGestureRecognizer.translation(in: collectionView.superview)
        if translation.y < 0 { cell.frame = CGRect(x: finalFrame.origin.x, y: 50, width: 0, height: 0) }
        UIView.animate(withDuration: 2.1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [.curveEaseInOut], animations: {
            cell.frame = finalFrame
        }, completion: { finished in
            cell.alpha = 1
        })
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension PlaylistViewController: UICollectionViewDelegate {
    
}
