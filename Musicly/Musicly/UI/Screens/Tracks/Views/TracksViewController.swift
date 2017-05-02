 //
 //  ViewController.swift
 //  Musically
 //
 //  Created by Christopher Webb-Orenstein on 4/9/17.
 //  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
 //
 
 import UIKit
 import RealmSwift
 
 
 enum TrackContentState {
    case none, loading, loaded, results
 }
 
 private let reuseIdentifier = "trackCell"
 
 final class TracksViewController: UIViewController {
    
    fileprivate var searchBar = UISearchBar() {
        didSet {
            searchBar.returnKeyType = .done
        }
    }
    
    var playlist: Playlist = Playlist()
    
    fileprivate let searchController = UISearchController(searchResultsController: nil)
    var contentState: TrackContentState = .none {
        didSet {
            switch contentState {
            case .none:
                self.view.bringSubview(toFront: emptyView)
            case .results:
                self.view.bringSubview(toFront: collectionView!)
            case.loaded:
                self.view.bringSubview(toFront: collectionView!)
            case .loading:
                return
            }
        }
    }
    var store: iTrackDataStore?
    var emptyView: EmptyView = EmptyView()
    
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
    
    var buttonItem: UIBarButtonItem!
    
    var collectionView : UICollectionView? = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    
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
        collectionView?.isHidden = true
        setupCollectionView()
        navigationItem.setRightBarButton(buttonItem, animated: false)
        setupDefaultUI()
        collectionView?.backgroundColor = CollectionViewConstants.backgroundColor
        setupSearchController()
    }
    func navigationBarSetup() {
        navigationController?.navigationBar.barTintColor = NavigationBarAttributes.navBarTint
        searchController.hidesNavigationBarDuringPresentation = false
        searchBar = searchController.searchBar
        navigationItem.titleView = searchBar
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = .white
        navigationItem.rightBarButtonItem?.tintColor = .white
        searchBar.becomeFirstResponder()
    }
    
    private func collectionViewRegister() {
        collectionView?.register(TrackCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView?.dataSource = self
        collectionView?.delegate = self
    }
    
    private func setupCollectionView() {
        let newLayout: TrackItemsFlowLayout = TrackItemsFlowLayout()
        newLayout.setup()
        collectionView?.collectionViewLayout = newLayout
        collectionView?.frame = UIScreen.main.bounds
        if let collectionView = collectionView {
            view.addSubview(collectionView)
            view.sendSubview(toBack: collectionView)
            view.bringSubview(toFront: emptyView)
        }
        collectionViewRegister()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        DispatchQueue.main.async { self.collectionView?.reloadData() }
    }
    
    func setSearchBarActive() {
        self.searchBarActive = true
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
        DispatchQueue.main.async {
            let destinationViewController: PlayerViewController = PlayerViewController()
            destinationViewController.playList = self.playlist
            destinationViewController.hidesBottomBarWhenPushed = true
            destinationViewController.index = indexPath.row
            self.navigationController?.pushViewController(destinationViewController, animated: false)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TrackCell
        
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
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if !searchBarActive {
            collectionView?.reloadData()
            searchBarActive = true
        }
        searchController.searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !searchBarActive {
            searchBarActive = true
            collectionView?.reloadData()
        }
        searchController.searchBar.resignFirstResponder()
    }
    
    fileprivate func setupSearchController() {
        setSearchBarColor(searchBar: searchBar)
        searchController.dimsBackgroundDuringPresentation = false
        searchController.definesPresentationContext = true
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        searchBar.barTintColor = .white
    }
    
    func searchBarHasInput() {
        guard let collectionView = collectionView else { return }
        collectionView.reloadData()
        playlist.removeAll()
        store?.searchForTracks { playlist, error in
            guard let playlist = playlist else { return }
            self.playlist = playlist
            collectionView.reloadData()
            collectionView.performBatchUpdates ({
                DispatchQueue.main.async {
                    self.contentState = .results
                    if let collectionView = self.collectionView {
                        collectionView.reloadItems(at: collectionView.indexPathsForVisibleItems)
                        collectionView.isHidden = false
                    }
                }
            }, completion: { finished in
                print(finished)
            })
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let barText = searchBar.text else { return }
        store?.setSearch(string: barText)
        searchBarActive = true
        if barText != "" { searchBarHasInput() }
        navigationController?.navigationBar.topItem?.title = "Search: \(barText)"
        UIView.animate(withDuration: 1.8) {
            self.collectionView?.alpha = 1
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
        collectionView?.reloadData()
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
        collectionView?.reloadData()
        navigationItem.setRightBarButton(buttonItem, animated: false)
        searchBarActive = false
    }
 }
