 //
 //  ViewController.swift
 //  Musically
 //
 //  Created by Christopher Webb-Orenstein on 4/9/17.
 //  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
 //
 
 import UIKit
 
 private let reuseIdentifier = "trackCell"
 private let headerIdentifier = "headerView"
 
 final class TracksViewController: UIViewController {
    
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
    let searchController = UISearchController(searchResultsController: nil)
    weak var store: iTrackDataStore? = iTrackDataStore(searchTerm: "")
    var tracks: [iTrack?]?
    var searchBarActive: Bool = false
    
    fileprivate lazy var small: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = EdgeAttributes.sectionInset
        layout.itemSize = RowSize.smallLayout.rawValue
        layout.minimumInteritemSpacing = SmallLayoutProperties.minimumInteritemSpacing
        layout.minimumLineSpacing = SmallLayoutProperties.minimumLineSpacing
        return layout
    }()
    
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
        setupDefaultUI()
        edgesForExtendedLayout = [.all]
        navigationController?.navigationBar.barTintColor = NavigationBarAttributes.navBarTint
        setupCollectionView()
        title = "Music.ly"
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView?.collectionViewLayout.invalidateLayout()
        collectionView?.layoutIfNeeded()
    }
    
    func setCollectionView() {
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.frame = UIScreen.main.bounds
        collectionView?.backgroundColor = CollectionViewAttributes.backgroundColor
        view.addSubview(collectionView!)
        collectionView?.setupMusicIcon(icon: musicIcon)
        collectionView?.setupInfoLabel(infoLabel: infoLabel)
        collectionViewRegister()
    }
    
    private func collectionViewRegister() {
        collectionView?.register(TrackCell.self,
                                forCellWithReuseIdentifier: reuseIdentifier)
        collectionView?.register(HeaderReusableView.self,
                                forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                                withReuseIdentifier: headerIdentifier)
        collectionView?.dataSource = self
        collectionView?.delegate = self
    }
    
    fileprivate func setupFlow(flowLayout: UICollectionViewFlowLayout) {
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 0
    }
    
    fileprivate func setupLayout(layout: UICollectionViewFlowLayout) {
        layout.sectionInset = EdgeAttributes.sectionInset
        layout.minimumInteritemSpacing = 5.0
        layout.minimumLineSpacing = 5.0
        layout.itemSize = RowSize.item.rawValue
        collectionView?.collectionViewLayout = layout
        setCollectionView()
    }
    
    fileprivate func setupCollectionView() {
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            let newLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            setupFlow(flowLayout: flowLayout)
            collectionView?.collectionViewLayout.invalidateLayout()
            collectionView?.layoutIfNeeded()
            setupLayout(layout: newLayout)
        }
        collectionView?.backgroundColor = UIColor(red:0.97, green:0.97, blue:0.97, alpha:1.0)
        view.addSubview(collectionView!)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBarActive = cancelSearching(searchBar, searchBarActive: searchBarActive)
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchBarActive = false
        searchBar.setShowsCancelButton(false, animated: false)
    }
 }
 
 extension TracksViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let tracks = tracks {
            return TrackCounter().getCount(for: tracks)
        }
        return 0
    }
 }
 
 extension TracksViewController {
    
    fileprivate func setTrackCell(indexPath: IndexPath?, cell: TrackCell) {
        if let index = indexPath,
            let track = tracks?[index.row] {
            cell.configureWith(track)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let track = tracks?[indexPath.row] {
            let destinationVC = PlayerViewController()
            destinationVC.track = track
            navigationController?.pushViewController(destinationVC, animated: false)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! TrackCell
        setTrackCell(indexPath: indexPath, cell: cell)
        return cell
    }
 }
 
 extension TracksViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return RowSize.header.rawValue
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionViewLayout == small {
            return RowSize.smallLayout.rawValue
        }
        return RowSize.track.rawValue
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return EdgeAttributes.edgeForStandard
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumItemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
 }
 
 extension TracksViewController: UISearchControllerDelegate {
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBarActive = true
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBarActive = false
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if !searchBarActive {
            searchBarActive = true
            collectionView?.reloadData()
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
    
    fileprivate func noSearchBarInput() {
        musicIcon.isHidden = false
        infoLabel.isHidden = false
        tracks?.removeAll()
        collectionView?.updateLayout(newLayout: small)
    }
    
    func searchBarHasInput() {
        collectionView?.backgroundView?.isHidden = true
        tracks?.removeAll()
        infoLabel.isHidden = true
        musicIcon.isHidden = true
        store?.searchForTracks { tracks, error in
            self.tracks = tracks
            self.collectionView?.collectionViewLayout.invalidateLayout()
            self.collectionView?.updateLayout(newLayout: self.small)
            self.collectionView?.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBarActive = true
        let barText = searchBar.getTextFromBar()
        store = iTrackDataStore(searchTerm: barText)
        barText == "" ? noSearchBarInput() : searchBarHasInput()
        navigationController?.navigationBar.topItem?.title = "Search: \(barText)"
    }
    
    func cancelSearching(_ searchBar: UISearchBar, searchBarActive: Bool) -> Bool {
        return false
    }
 }
 
 extension TracksViewController: UISearchResultsUpdating {
    
    func filterContentForSearchText(searchText: String) {
        print("filter")
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchString = searchController.searchBar.text
        
        if searchString != nil {
            store?.setSearch(string: searchString!)
            store?.searchForTracks { tracks, error in
                self.store?.searchForTracks { tracks, error in
                    self.tracks = tracks
                }
            }
        }
        collectionView?.reloadData()
    }
    
    public func updateSearchResults(for searchController: UISearchController) {
        searchBarActive = true
    }
 }
 
 extension TracksViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBarActive = false
        noSearchBarInput()
    }
    
    func setHeader(headerView: HeaderReusableView) {
        headerView.frame = HeaderViewProperties.frame
        setupResuableView(headerView)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
            
        case UICollectionElementKindSectionHeader:
            let reusableView = collectionView.getHeader(indexPath: indexPath, identifier: headerIdentifier)
            setHeader(headerView: reusableView)
            return reusableView
            
        default:
            fatalError("Unexpected element kind")
        }
    }
    
    func setupResuableView(_ reuseableView: HeaderReusableView) {
        reuseableView.searchBar = searchController.searchBar
        reuseableView.searchBar.delegate = self
        setSearchBarColor(searchBar: reuseableView.searchBar)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        reuseableView.searchBar.delegate = self
        reuseableView.searchBar.barTintColor = .white
    }
 }
