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
    var searchBar = UISearchBar()
    let searchController = UISearchController(searchResultsController: nil)
    var store: iTrackDataStore? = iTrackDataStore(searchTerm: "")
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
        loadData()
        edgesForExtendedLayout = [.all]
        navigationController?.navigationBar.barTintColor = NavigationBarAttributes.navBarTint
        setupCollectionView()
        title = "Music.ly"
        collectionView?.isHidden = true
        searchBar = searchController.searchBar
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        setup()
        searchController.hidesNavigationBarDuringPresentation = false
    }
    
    func loadData() {
        self.store?.setSearch(string: "Test")
        self.store?.searchForTracks { tracks, errors in
            self.tracks = tracks
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView?.collectionViewLayout.invalidateLayout()
        collectionView?.layoutIfNeeded()
    }
    
    func setupMusicIcon(icon: UIView) {
        view.addSubview(icon)
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.18).isActive = true
        icon.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.35).isActive = true
        icon.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        icon.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: UIScreen.main.bounds.height * -0.13).isActive = true
    }
    
    func setupInfoLabel(infoLabel: UILabel) {
        view.addSubview(infoLabel)
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5).isActive = true
        infoLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
        infoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        infoLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: UIScreen.main.bounds.height * 0.02).isActive = true
    }
    
    func setCollectionView() {
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.frame = UIScreen.main.bounds
        collectionView?.backgroundColor = CollectionViewAttributes.backgroundColor
        view.backgroundColor = CollectionViewAttributes.backgroundColor
        view.addSubview(collectionView!)
        setupMusicIcon(icon: musicIcon)
        setupInfoLabel(infoLabel: infoLabel)
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
        return 50
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
        updateLayout(newLayout: small)
    }
    
    func updateLayout(newLayout: UICollectionViewLayout) {
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
            self.collectionView?.setCollectionViewLayout(newLayout, animated: true)
        }
    }
    
    func setup() {
        setSearchBarColor(searchBar: searchBar)
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.definesPresentationContext = true
        searchBar.barTintColor = .white
    }
    
    func searchBarHasInput() {
        collectionView?.backgroundView?.isHidden = true
        tracks?.removeAll()
        infoLabel.isHidden = true
        musicIcon.isHidden = true
        store?.searchForTracks { tracks, error in
            self.tracks = tracks
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
            self.collectionView?.performBatchUpdates ({
                DispatchQueue.main.async {
                    self.collectionView?.reloadItems(at: (self.collectionView?.indexPathsForVisibleItems)!)
                    self.collectionView?.isHidden = false
                }
            }, completion: { finished in
                print(finished)
            })
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBarActive = true
        let barText = searchBar.getTextFromBar()
        store?.setSearch(string: barText)
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
    
 }
