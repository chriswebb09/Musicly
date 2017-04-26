 //
 //  ViewController.swift
 //  Musically
 //
 //  Created by Christopher Webb-Orenstein on 4/9/17.
 //  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
 //
 
 import UIKit
 import RealmSwift
 
 private let reuseIdentifier = "trackCell"
 
 final class TracksViewController: UIViewController {
    
    fileprivate var searchBar = UISearchBar() {
        didSet {
            searchBar.returnKeyType = .done
        }
    }
    
    var playlist: Playlist = Playlist()
    
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
    var infoLabel: UILabel = UILabel.setupInfoLabel()
    
    var musicIcon: UIImageView = {
        var musicIcon = UIImageView()
        musicIcon.image = #imageLiteral(resourceName: "headphones-blue")
        return musicIcon
    }()
    
    var collectionView : UICollectionView? = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.delegate = self
        image = image.withRenderingMode(.alwaysOriginal)
        title = "Music.ly"
        commonInit()
        setSearchBarColor(searchBar: searchBar)
        let tabController = self.tabBarController as! TabBarController
        self.store = tabController.store
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
    
    // TODO: - Consolidate navigation bar and buttonItem methods
    
    func commonInit() {
        buttonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(navigationBarSetup))
        edgesForExtendedLayout = [.all]
        collectionView?.isHidden = true
        setupCollectionView()
        navigationItem.setRightBarButton(buttonItem, animated: false)
        setupDefaultUI()
        setup()
        collectionView?.backgroundColor = CollectionViewConstants.backgroundColor
        collectionView?.setuLayout()
    }
    
    func navigationBarSetup() {
        navigationController?.navigationBar.barTintColor = NavigationBarAttributes.navBarTint
        searchController.hidesNavigationBarDuringPresentation = false
        searchBar = searchController.searchBar
        navigationItem.titleView = searchBar
        searchBar.delegate = self
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
            setupInfoLabel(infoLabel: infoLabel)
            setupMusicIcon(icon: musicIcon)
            
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
            }
        }
    }
 }
 
 extension TracksViewController {
    
    func setupPlayerController() -> PlayerViewController {
        let destinationViewController: PlayerViewController = PlayerViewController()
        destinationViewController.playList = playlist
        destinationViewController.hidesBottomBarWhenPushed = true
        return destinationViewController
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        let destinationViewController = setupPlayerController()
        guard let selectedIndex = selectedIndex else { return }
        destinationViewController.index = selectedIndex
        navigationController?.pushViewController(destinationViewController, animated: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TrackCell
        if let track = playlist.playlistItem(at: indexPath.row)?.track {
            let cellViewModel = TrackCellViewModel(trackName: track.trackName, albumImageUrl: URL(string: track.artworkUrl)!)
            cell.configureCell(with: cellViewModel, withTime: 0)
        }
        
        DispatchQueue.main.async {
            let finalFrame = cell.frame
            
            let translation: CGPoint = collectionView.panGestureRecognizer.translation(in: collectionView.superview)

            if translation.y < 0 {
                cell.frame = CGRect(x: finalFrame.origin.x + 10, y: 50, width: 300, height: -200)
            }
            
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [.curveEaseInOut], animations: {
                cell.alpha = 1
                cell.frame = finalFrame
            }, completion: { finished in
                
            })

        }

        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if let cell = collectionView.cellForItem(at: indexPath) as? TrackCell {
            DispatchQueue.main.async {
                let finalFrame = cell.frame
                
                let translation: CGPoint = collectionView.panGestureRecognizer.translation(in: collectionView.superview)
                
                if translation.x < 0 {
                    cell.frame = CGRect(x: finalFrame.origin.x - 5000, y: -500, width: 500, height: 200)
                } else {
                    cell.frame = CGRect(x: finalFrame.origin.x + 500, y: -500, width: 500, height: 600)
                }
                
                
                UIView.animate(withDuration: 26) {
                    cell.frame = finalFrame
                }
            }
        }
    }
 }
 
 // MARK: - UICollectionViewDelegate
 
 extension TracksViewController: UICollectionViewDelegate {
    
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
    
    func toggle(to: Bool) {
        infoLabel.isHidden = to
        musicIcon.isHidden = to
    }
    
    fileprivate func setup() {
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
        collectionView.backgroundView?.isHidden = true
        toggle(to: true)
        collectionView.reloadData()
        self.playlist.removeAll()
        store?.searchForTracks { playlist, error in
            guard let playlist = playlist else { return }
            self.playlist = playlist
            collectionView.reloadData()
            collectionView.performBatchUpdates ({
                DispatchQueue.main.async {
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
        let barText = searchBar.getTextFromBar()
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
    
    func filterContentForSearchText(searchText: String) {
        print("filter")
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchString = searchController.searchBar.text
        if searchString != nil {
            playlist.removeAll()
            if let searchString = searchString {
                store?.setSearch(string: searchString)
                store?.searchForTracks { tracks, error in
                    self.store?.searchForTracks { tracks, error in
                        self.playlist = tracks!
                    }
                }
            }
        }
        collectionView?.reloadData()
    }
    
    public func updateSearchResults(for searchController: UISearchController) {
        searchBarActive = true
    }
 }
 
 // MARK: - UISearchBarDelegate
 
 extension TracksViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        playlist.removeAll()
        toggle(to: false)
        setupInfoLabel(infoLabel: infoLabel)
        setupMusicIcon(icon: musicIcon)
        collectionView?.reloadData()
        navigationItem.setRightBarButton(buttonItem, animated: false)
        searchBarActive = false
    }
 }
