//
//  PlaylistViewController.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 4/19/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

private let reuseIdentifier = "PlaylistCell"

class PlaylistViewController: UIViewController {
    let detailPop = DetailPopover()
    var playlists: [Playlist]?
    var collectionView : UICollectionView? = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    var store: iTrackDataStore? {
        didSet {
            self.playlists = store?.playlists
        }
    }
    var rightBarButtonItem: UIBarButtonItem?
    
    
    override func viewDidLoad() {
        edgesForExtendedLayout = []
        title = "Playlists"
        setupCollectionView()
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.register(PlaylistCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView?.backgroundColor = UIColor(red:0.97, green:0.97, blue:0.97, alpha:1.0)
        view.addSubview(collectionView!)
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
    }
    
    func newPlaylist() {
        
    }
    
    func setupCollectionView() {
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .vertical
            flowLayout.minimumLineSpacing = 0
        }
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionView?.collectionViewLayout.invalidateLayout()
        layout.sectionInset = UIEdgeInsets(top:10, left: 0, bottom: 60, right: 0)
        layout.itemSize = CGSize(width: view.bounds.width, height: 150)
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
    }
    
}

extension PlaylistViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let store = store {
            return store.playlists.count
        } else {
            return 2
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PlaylistCell
        if let playlist = playlists {
            let last = playlist.last
            
            if let lastTrack = last?.playlistItem(at: 0) {
                let url = lastTrack.track?.artworkUrl
                let arturl = URL(string: url!)
                if let arturl = arturl {
                    cell.configure(playlistName: (lastTrack.track?.trackName)!, artUrl: arturl)
                }
            }
        }
        return cell
    }
    
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        guard let playlist = self.playlists?.last else { return }
//        detailPop.popView.configureView(playlist: playlist)
//        UIView.animate(withDuration: 0.15, animations: {
//            self.detailPop.showPopView(viewController: self)
//            self.detailPop.popView.isHidden = false
//            let zoomOutTranform: CGAffineTransform = CGAffineTransform(scaleX: 10, y: 10)
//           
//        })
//        self.detailPop.popView.doneButton.addTarget(self, action: #selector(hidePop), for: .touchUpInside)
//
//    }
    
    func pop() {
        guard let playlist = self.playlists?.last else { return }
        detailPop.popView.configureView(playlist: playlist)
        detailPop.popView.doneButton.backgroundColor = UIColor(red:0.13, green:0.21, blue:0.44, alpha:1.0)
        UIView.animate(withDuration: 0.15) {
            self.detailPop.showPopView(viewController: self)
            self.detailPop.popView.isHidden = false
            let zoomOutTranform: CGAffineTransform = CGAffineTransform(scaleX: 10, y: 10)
            
        }
        self.detailPop.popView.doneButton.addTarget(self, action: #selector(hidePop), for: .touchUpInside)
    }
    
    func hidePop() {
        detailPop.hidePopView(viewController: self)
        detailPop.popView.isHidden = true
        view.sendSubview(toBack: detailPop)
    }
    
}

extension PlaylistViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top:0, left: 0, bottom: 60, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumItemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}
