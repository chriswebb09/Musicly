//
//  PlaylistViewController.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 4/19/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

private let reuseIdentifier = "PlaylistCell"

class PlaylistViewController: UIViewController {
    
    var realm: Realm?
    
    let detailPop = DetailPopover()
    var playlists: [Playlist]?
    var collectionView : UICollectionView? = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    var store: iTrackDataStore?
    var rightBarButtonItem: UIBarButtonItem?
    var playlistList: Results<TrackList>!
    var testID: Results<CurrentListID>!
    var trackList: [TrackList]!
    var tracklist: [TrackList]!
    
    override func viewDidLoad() {
        edgesForExtendedLayout = []
        title = "Playlists"
        setupCollectionView()
        
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.register(PlaylistCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView?.backgroundColor = PlaylistViewControllerConstants.backgroundColor
        
        
        view.addSubview(collectionView!)
        detailPop.popView.playlistNameField.delegate = self
        self.rightBarButtonItem = UIBarButtonItem.init(
            title: "New",
            style: .done,
            target: self,
            action: #selector(pop)
        )
        
        guard let rightButtonItem = self.rightBarButtonItem else { return }
        let tabController = self.tabBarController as! TabBarController
        self.store = tabController.store
        navigationItem.rightBarButtonItems = [rightButtonItem]
        add()
    }
    
    func add() {
        if let realm = try? Realm() {
            testID = realm.objects(CurrentListID.self)
            let test = testID.first
            let lists = realm.objects(TrackList.self).filter("listId == %@", test?.id)
            self.tracklist = Array(lists)
            let testsList = realm.objects(TrackList.self)
            self.trackList = Array(testsList)
            dump(tracklist.count)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }
    func save() {
    }
    
    func setupCollectionView() {
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .vertical
            flowLayout.minimumLineSpacing = 0
        }
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionView?.collectionViewLayout.invalidateLayout()
        layout.sectionInset = PlaylistViewControllerConstants.edgeInset
        layout.itemSize = PlaylistViewControllerConstants.itemSize
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
    }
}

extension PlaylistViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trackList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PlaylistCell
        let test = trackList[indexPath.row]
        let item = test.tracks[0]
        let url = URL(string: item.artworkUrl)!
        cell.configure(playlistName: item.playlistID, artUrl: url)
        return cell
    }
    
    func pop() {
        detailPop.popView.configureView()
        detailPop.popView.doneButton.backgroundColor = PlaylistViewControllerConstants.mainColor
        UIView.animate(withDuration: 0.15) {
            self.detailPop.showPopView(viewController: self)
            self.detailPop.popView.isHidden = false
        }
        self.detailPop.popView.doneButton.addTarget(self, action: #selector(hidePop), for: .touchUpInside)
    }
    
    func hidePop() {
        setupNewList()
        detailPop.hidePopView(viewController: self)
        detailPop.popView.isHidden = true
        view.sendSubview(toBack: detailPop)
    }
    
    func setupNewList() -> TrackList? {
        let trackList = TrackList()
        trackList.listId = UUID().uuidString
        trackList.listName = "Test list"
        guard let store = store else { return nil }
        let test = store.newTracks
        test.forEach {
            let new = $0
            new.playlistID = trackList.listId
            trackList.tracks.append(new)
        }
        
        let current = CurrentListID()
        current.id = trackList.listId
        
        if let realm = try? Realm() {
            testID = realm.objects(CurrentListID.self)
            if !testID.contains(current) {
                try! realm.write {
                    realm.add(current)
                }
            }
        }
        if let realm = try? Realm() {
            playlistList = realm.objects(TrackList.self)
            if !playlistList.contains(trackList) {
                try! realm.write {
                    realm.add(trackList)
                }
            }
            testID = realm.objects(CurrentListID.self)
            if !testID.contains(current) {
                try! realm.write {
                    realm.add(current)
                }
            }
        }
        return trackList
    }
}

extension PlaylistViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return PlaylistViewControllerConstants.collectionItemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return PlaylistViewControllerConstants.collectionViewEdge
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumItemSpacingForSectionAt section: Int) -> CGFloat {
        return PlaylistViewControllerConstants.minimumSpace
    }
}

extension PlaylistViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


