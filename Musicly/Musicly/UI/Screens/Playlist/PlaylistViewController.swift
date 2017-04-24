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

class PlaylistViewController: UIViewController {
    
    var realm: Realm?
    let detailPop = DetailPopover()
    var playlists: [Playlist]?
    var collectionView : UICollectionView? = UICollectionView.setupCollectionView()
    
    var store: iTrackDataStore? {
        didSet {
            print(store?.trackLists.last)
        }
    }
    
    var rightBarButtonItem: UIBarButtonItem?
    var listID: Results<CurrentListID>!
    var trackList: [TrackList]!
    
    override func viewDidLoad() {
        edgesForExtendedLayout = []
        title = "Playlists"
        self.collectionView = UICollectionView.setupCollectionView()
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
        
        navigationItem.rightBarButtonItems = [rightButtonItem]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tabController = self.tabBarController as! TabBarController
        self.store = tabController.store
        self.trackList = Array(store!.trackLists)
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
            
        }
    }
}

extension PlaylistViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let trackList = trackList else { return 0 }
        return trackList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PlaylistCell
        if trackList.count <= 0 {
            cell.configure(playlistName: "Test", artUrl: nil)
        } else {
            cell.configure(playlistName: "List", artUrl: nil)
        }
        return cell
    }
    
    func pop() {
        detailPop.popView.configureView()
        detailPop.popView.doneButton.backgroundColor = PlaylistViewControllerConstants.mainColor
        detailPop.popView.doneButton.setTitleColor(.white, for: .normal)
        detailPop.popView.doneButton.titleLabel!.font = UIFont(name: "Avenir-Book", size: 18)!
        detailPop.popView.doneButton.setTitle("Done", for: .normal)
        UIView.animate(withDuration: 0.15) {
            self.detailPop.showPopView(viewController: self)
            self.detailPop.popView.isHidden = false
        }
        self.detailPop.popView.doneButton.addTarget(self, action: #selector(hidePop), for: .touchUpInside)
    }
    
    func hidePop() {
        guard let nameText = detailPop.popView.playlistNameField.text else { return }
        self.store?.createNewList(name: nameText)
        
        if let last = store?.trackLists.last {
            trackList.append(last)
        }
        
        detailPop.hidePopView(viewController: self)
        detailPop.popView.isHidden = true
        view.sendSubview(toBack: detailPop)
        
        if let zeroList = self.store?.lists[0] {
            self.trackList.append(zeroList)
        }
        
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }
    
    func setupNewList(name: String) -> TrackList {
        let list = TrackList()
        list.date = String(describing: NSDate())
        list.listId = UUID().uuidString
        list.listName = name
        
        return list
    }
    
    func saveTrackList(trackList: TrackList) {
        let lists: Results<TrackList>!
        if let realm = try? Realm() {
            lists = realm.objects(TrackList.self)
            if !lists.contains(trackList) {
                try! realm.write {
                    realm.add(trackList)
                }
            }
        }
    }
    
    func saveCurrentListID(newID: CurrentListID) {
        if let realm = try? Realm() {
            self.listID = realm.objects(CurrentListID.self)
            if !self.listID.contains(newID) {
                try! realm.write {
                    realm.add(newID)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(trackList[indexPath.row].listId)
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
