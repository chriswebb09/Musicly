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
    
    fileprivate var searchBar = UISearchBar() {
        didSet {
            searchBar.returnKeyType = .done
        }
    }
    
    var playlist: Playlist = Playlist()
    
    var tracklist: TrackList = TrackList() {
        didSet {
            for track in tracklist.tracks {
                let newItem = PlaylistItem()
                newItem.track = track
                playlist.append(newPlaylistItem: newItem)
            }
        }
    }
    
    fileprivate var selectedIndex: Int?
    fileprivate var selectedImage = UIImageView()
    fileprivate let searchController = UISearchController(searchResultsController: nil)
    
    var store: iTrackDataStore?
    
    fileprivate var searchBarActive: Bool = false {
        didSet {
            if searchBarActive == true {
                navigationItem.rightBarButtonItems = []
            } else {
                if let buttonItem = buttonItem {
                    navigationItem.rightBarButtonItems = [buttonItem]
                }
            }
        }
    }
    
    fileprivate var image = #imageLiteral(resourceName: "search-button")
   
    var buttonItem: UIBarButtonItem?
    var collectionView : UICollectionView? = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        image = image.withRenderingMode(.alwaysOriginal)
        title = tracklist.listName
        commonInit()
        setSearchBarColor(searchBar: searchBar)
        let tabController = tabBarController as! TabBarController
        store = tabController.store
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let searchBarText = searchBar.text, searchBarText.characters.count > 0 {
            searchBarActive = true
        }
        if searchBarActive == true {
            navigationItem.rightBarButtonItems = []
        } else {
            guard let buttonItem = buttonItem else { return }
            navigationItem.rightBarButtonItems = [buttonItem]
        }
    }
    
    func commonInit() {
        buttonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(navigationBarSetup))
        edgesForExtendedLayout = [.all]
        setupCollectionView()
        navigationItem.setRightBarButton(buttonItem, animated: false)
        setupDefaultUI()
        collectionView?.backgroundColor = CollectionViewConstants.backgroundColor
        collectionView?.setupLayout()
    }
    
    func navigationBarSetup() {
        tabBarController?.selectedIndex = 0
    }
    
    private func collectionViewRegister() {
        collectionView?.register(TrackCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView?.dataSource = self
        collectionView?.delegate = self
    }
    
    fileprivate func setupCollectionView() {
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            let newLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            newLayout.sectionInset = EdgeAttributes.sectionInset
            newLayout.itemSize = RowSize.item.rawValue
            newLayout.minimumInteritemSpacing = CollectionViewConstants.layoutSpacingMinItem
            newLayout.minimumLineSpacing = CollectionViewConstants.layoutSpacingMinLine
            flowLayout.scrollDirection = .vertical
            collectionView?.layoutIfNeeded()
            collectionView?.collectionViewLayout = newLayout
            view.backgroundColor = CollectionViewAttributes.backgroundColor
            collectionView?.frame = UIScreen.main.bounds
            
            if let collectionView = collectionView {
                view.addSubview(collectionView)
            }
            collectionViewRegister()
        }
        
        if let collectionView = collectionView {
            view.addSubview(collectionView)
        }
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: false)
        searchBarActive = false
    }
}

// MARK: - UICollectionViewDataSource

extension PlaylistViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tracklist.tracks.count
    }
    
    fileprivate func setTrackCell(indexPath: IndexPath?, cell: TrackCell) {
        if let index = indexPath, let track = playlist.playlistItem(at: index.row)?.track {
            if let url = URL(string: track.artworkUrl) {
                let viewModel = TrackCellViewModel(trackName: track.trackName, albumImageUrl: url)
                cell.configureCell(with: viewModel, withTime: 0)
            }
        }
    }
}

extension PlaylistViewController {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        let destinationViewController: PlayerViewController = PlayerViewController()
        destinationViewController.playList = playlist
        destinationViewController.hidesBottomBarWhenPushed = true
        guard let selectedIndex = selectedIndex else { return }
        destinationViewController.index = selectedIndex
        navigationController?.pushViewController(destinationViewController, animated: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TrackCell
        let track = tracklist.tracks[indexPath.row]
        let cellViewModel = TrackCellViewModel(trackName: track.trackName, albumImageUrl: URL(string: track.artworkUrl)!)
        cell.configureCell(with: cellViewModel, withTime: 0)
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension PlaylistViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return RowSize.header.rawValue
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionViewLayout == UICollectionViewFlowLayout.small() {
            return RowSize.smallLayout.rawValue
        }
        return RowSize.track.rawValue
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return EdgeAttributes.edgeForStandard
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumItemSpacingForSectionAt section: Int) -> CGFloat {
        return CollectionViewConstants.layoutSpacingMinItem
    }
}
