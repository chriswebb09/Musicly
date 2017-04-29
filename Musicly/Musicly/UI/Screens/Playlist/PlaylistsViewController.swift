//
//  PlaylistViewController.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 4/19/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit
import RealmSwift

private let reuseIdentifier = "PlaylistCell"

final class PlaylistsViewController: UIViewController {
    
    let detailPop = DetailPopover()
    var collectionView : UICollectionView?
    var tabController: TabBarController!
    var store: iTrackDataStore!
    var rightBarButtonItem: UIBarButtonItem!
    var trackList: [TrackList] = [TrackList]()
    
    override func viewDidLoad() {
        title = "Playlists"
        self.collectionView = setupPlaylistCollectionView()
        rightBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "blue-musicnote-1").withRenderingMode(UIImageRenderingMode.alwaysOriginal), style: .done, target: self, action: #selector(pop))
        tabController = tabBarController as! TabBarController
        collectionViewSetup()
        detailPop.popView.playlistNameField.delegate = self
        guard let rightButtonItem = rightBarButtonItem else { return }
        navigationItem.rightBarButtonItems = [rightButtonItem]
        let tabbar = tabBarController as! TabBarController
        store = tabbar.store
    }
    
    func collectionViewSetup() {
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.register(PlaylistCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView?.backgroundColor = PlaylistViewControllerConstants.backgroundColor
        guard let collectionView = collectionView else { return }
        view.addSubview(collectionView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        store = tabController.store
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }
}

extension PlaylistsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let tracklists = store.trackLists {
            DispatchQueue.main.async {
                self.trackList = Array(tracklists)
            }
        }
        return trackList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("PlaylistsViewController - cellForItemAt")
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
        detailPop.setupPop()
        UIView.animate(withDuration: 0.15) {
            self.detailPop.showPopView(viewController: self)
            self.detailPop.popView.isHidden = false
        }
        detailPop.popView.doneButton.addTarget(self, action: #selector(hidePop), for: .touchUpInside)
    }
    
    func hidePop() {
        guard let nameText = detailPop.popView.playlistNameField.text else { return }
        store.createNewList(name: nameText)
        if let tracklists = store.trackLists, let last = tracklists.last {
            trackList.append(last)
        }
        detailPop.hidePopView(viewController: self)
        detailPop.popView.isHidden = true
        view.sendSubview(toBack: detailPop)
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }
}

extension PlaylistsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destinationVC = PlaylistViewController()
        destinationVC.tracklist = trackList[indexPath.row]
        destinationVC.title = trackList[indexPath.row].listName
        store.currentPlaylistID = trackList[indexPath.row].listId
        store.setCurrentPlaylist()
        navigationController?.pushViewController(destinationVC, animated: false)
    }
}

extension PlaylistsViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func setupPlaylistCollectionView() -> UICollectionView {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: layout)
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .vertical
            flowLayout.minimumLineSpacing = 10
        }
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        layout.itemSize = PlaylistViewControllerConstants.itemSize
        return collectionView
    }
}
