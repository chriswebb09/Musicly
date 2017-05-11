 //
 //  ViewController.swift
 //  Musically
 //
 //  Created by Christopher Webb-Orenstein on 4/9/17.
 //  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
 //
 
 import UIKit
 import RealmSwift
 
 protocol EmptyViewProtocol {
    func setupEmptyView(emptyView: EmptyView, for view: UIView)
 }
 
 extension EmptyViewProtocol {
    func setupEmptyView(emptyView: EmptyView, for view: UIView) {
        view.addSubview(emptyView)
        emptyView.layoutSubviews()
        emptyView.frame = view.frame
    }
 }
 
 private let reuseIdentifier = "trackCell"
 
 final class TracksViewController: UIViewController {
    
    var buttonItem: UIBarButtonItem!
    lazy var collectionView : UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    var playlist: Playlist = Playlist()
    var searchController = UISearchController(searchResultsController: nil)
    var store: iTrackDataStore?
    var emptyView: EmptyView = EmptyView()
    var fromPlaylist: Bool = false
    
    var searchBar = UISearchBar() {
        didSet {
            searchBar.returnKeyType = .done
        }
    }
    
    var contentState: TrackContentState = .none {
        didSet {
            switch contentState {
            case .none:
                self.view.bringSubview(toFront: emptyView)
            case .results:
                self.view.bringSubview(toFront: collectionView)
            case.loaded:
                self.view.bringSubview(toFront: collectionView)
            case .loading:
                return
            }
        }
    }
    
    var searchBarActive: Bool = false {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let realmUrl = Realm.Configuration.defaultConfiguration.fileURL else { return }
        print(realmUrl)
        view.addSubview(emptyView)
        emptyView.layoutSubviews()
        emptyView.frame = view.frame
        searchController.delegate = self
        title = "Music.ly"
        commonInit()
        let tabController = tabBarController as! TabBarController
        tabController.store = iTrackDataStore()
        store = tabController.store
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let searchBarText = searchBar.text, searchBarText.characters.count > 0 { searchBarActive = true }
    }
    
    func commonInit() {
        buttonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "search-button").withRenderingMode(.alwaysOriginal),
                                     style: .plain,
                                     target: self,
                                     action: #selector(navigationBarSetup))
        edgesForExtendedLayout = []
        collectionView.isHidden = true
        setupCollectionView()
        navigationItem.setRightBarButton(buttonItem, animated: false)
        setupDefaultUI()
        collectionView.backgroundColor = CollectionViewConstants.backgroundColor
        setupSearchController(with: searchBar)
    }
    
    
    func navigationBarSetup() {
        guard let navigationController = navigationController else { return }
        navigationController.navigationBar.barTintColor = NavigationBarAttributes.navBarTint
        searchController.hidesNavigationBarDuringPresentation = false
        searchBar = searchController.searchBar
        navigationItem.titleView = searchBar
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = .white
        navigationItem.rightBarButtonItem?.tintColor = .white
        searchBarActive = true
        searchBar.becomeFirstResponder()
        
        print(searchBar.isFirstResponder)
    }
    
    private func setupCollectionView() {
        let newLayout: TrackItemsFlowLayout = TrackItemsFlowLayout()
        newLayout.setup()
        setupEmptyView(emptyView: emptyView, for: view)
        collectionView.collectionViewLayout = newLayout
        collectionView.frame = UIScreen.main.bounds
        guard let tabbarHeight = self.tabBarController?.tabBar.frame.height else { return }
        collectionView.contentInset =  UIEdgeInsets(top: 0, left: 0, bottom: tabbarHeight + 20, right: 0)
        arrangeViewOrder(collectionView: collectionView, emptyView: emptyView)
        collectionViewRegister(collectionView: collectionView, viewController: self, identifier: reuseIdentifier)
    }
    
    func arrangeViewOrder(collectionView: UICollectionView, emptyView: EmptyView) {
        view.addSubview(collectionView)
        view.sendSubview(toBack: collectionView)
        view.bringSubview(toFront: emptyView)
    }
    
//    func setupEmptyView(emptyView: EmptyView) {
//        view.addSubview(emptyView)
//        emptyView.layoutSubviews()
//        emptyView.frame = view.frame
//    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func setSearchBarActive(isActive: Bool) {
        self.searchBarActive = isActive
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: false)
        searchBarActive = false
    }
 }
 
 // MARK: - UICollectionViewDataSource
 
 extension TracksViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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
                print("Rowtime: \(rowTime)")
                UIView.animate(withDuration: rowTime / 10) {
                    cell.alpha = 1
                }
            }
        }
    }
 }
 
 // MARK: - UICollectionViewDelegate
 
 extension TracksViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destinationViewController: PlayerViewController = PlayerViewController()
        destinationViewController.playList = self.playlist
        destinationViewController.hidesBottomBarWhenPushed = true
        destinationViewController.index = indexPath.row
        navigationController?.pushViewController(destinationViewController, animated: false)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackCell.identifier, for: indexPath) as! TrackCell
        DispatchQueue.main.async {
            self.setTrackCell(indexPath: indexPath, cell: cell)
        }
        return cell
    }
 }
 
 // MARK: - UISearchController Delegate
 
 extension TracksViewController: UISearchControllerDelegate {
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        playlist.removeAll()
        searchBar.setShowsCancelButton(true, animated: true)
        searchBarActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBarActive = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searchBarSearchButtonClicked")
        DispatchQueue.main.async {
            self.navigationItem.rightBarButtonItems = []
        }
        
        if !searchBarActive {
            //searchBarActive = true
            collectionView.reloadData()
        }
        searchController.searchBar.resignFirstResponder()
    }
    
    func setupSearchController(with searchBar: UISearchBar) {
        setSearchBarColor(searchBar: searchBar)
        searchController.dimsBackgroundDuringPresentation = false
        searchController.definesPresentationContext = true
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        searchBar.barTintColor = .white
    }
    
    func updateContent(collectionView: UICollectionView, playlist: Playlist) {
        removeContent(collectionView: collectionView, playlist: playlist)
        guard let store = store else { return }
        search(store: store, collectionView: collectionView)
        self.collectionView.performBatchUpdates ({
            DispatchQueue.main.async {
                self.contentState = .results
                self.collectionView.reloadItems(at: self.collectionView.indexPathsForVisibleItems)
                self.collectionView.isHidden = false
            }
        }, completion: { finished in
            print(finished)
        })
    }
    
    func search(store: iTrackDataStore, collectionView: UICollectionView) -> Bool {
        var success = false
        store.searchForTracks { playlist, error in
            guard let playlist = playlist else { return }
            self.playlist = playlist
            collectionView.reloadData()
            success = true
        }
        return success
    }
    
    func removeContent(collectionView: UICollectionView, playlist: Playlist) {
        collectionView.reloadData()
        playlist.removeAll()
    }
    
    func searchBarHasInput(searchBar: UISearchBar) -> Bool {
        return searchBar.hasInput
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBarHasInput(searchBar: searchBar), let barText = searchBar.text {
            store?.setSearch(string: barText)
            searchBarActive = true
            navigationController?.navigationBar.topItem?.title = "Search: \(barText)"
            updateContent(collectionView: collectionView, playlist: playlist)
        }
        UIView.animate(withDuration: 1.8) {
            self.collectionView.alpha = 1
        }
    }
 }
 
 // MARK: - UISearchResultsUpdating
 
 extension TracksViewController: UISearchResultsUpdating {
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchString = searchController.searchBar.text
        if searchString != nil {
            playlist.removeAll()
            if let searchString = searchString {
                store?.setSearch(string: searchString)
                store?.searchForTracks { tracks, error in
                    self.store?.searchForTracks { tracks, error in
                        guard let tracks = tracks else { return }
                        self.playlist = tracks
                    }
                }
            }
        }
        collectionView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        searchBarActive = true
    }
 }
 
 // MARK: - UISearchBarDelegate
 
 extension TracksViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        playlist.removeAll()
        contentState = .none
        collectionView.reloadData()
        navigationItem.setRightBarButton(buttonItem, animated: false)
        searchBarActive = false
    }
 }
 
 extension TracksViewController: TrackCellCollectionProtocol, EmptyViewProtocol {
    
 }
