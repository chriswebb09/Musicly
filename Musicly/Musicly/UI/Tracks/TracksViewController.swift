 //
 //  ViewController.swift
 //  Musically
 //
 //  Created by Christopher Webb-Orenstein on 4/9/17.
 //  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
 //
 
 import UIKit
 import AVFoundation
 
 private let reuseIdentifier = "trackCell"
 let headerIdentifier = "headerView"
 fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
 
 final class TracksViewController: UIViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var store: iTrackDataStore?
    var tracks: [iTrack?]?
    var downloads: [String: Download?]?
    var collections: [String] = [String]()
    
    lazy var player: AVPlayer = {
        return AVPlayer()
    }()
    
    var searchBarActive: Bool = false
    
    fileprivate lazy var small: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = EdgeAttributes.sectionInset
        layout.itemSize = RowSize.smallLayout.rawValue
        layout.minimumInteritemSpacing = SmallLayoutProperties.minimumInteritemSpacing
        layout.minimumLineSpacing = SmallLayoutProperties.minimumLineSpacing
        return layout
    }()
    
    fileprivate lazy var big: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = EdgeAttributes.sectionInset
        layout.itemSize = RowSize.largeLayout.rawValue
        return layout
    }()
    
    var infoLabel: UILabel = {
        var infoLabel = UILabel()
        infoLabel.textAlignment = .center
        infoLabel.text = "Search for music"
        return infoLabel
    }()
    
    
    var collectionView : UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.delegate = self
        let cancelButtonAttributes: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes as? [String : AnyObject], for: UIControlState.normal)
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = .lightGray
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = NSAttributedString(string: "Search for songs...", attributes: [NSForegroundColorAttributeName: UIColor.black])
        
        store = iTrackDataStore(searchTerm: "new")
        edgesForExtendedLayout = [.all]
        navigationController?.navigationBar.barTintColor = NavigationBarAttributes.navBarTint
        setupCollectionView()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.layoutIfNeeded()
    }
    
    func setCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.frame = UIScreen.main.bounds
        collectionView.backgroundColor = CollectionViewAttributes.backgroundColor
        
        view.addSubview(collectionView)
        collectionView.addSubview(infoLabel)
        
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.heightAnchor.constraint(equalTo: collectionView.heightAnchor, multiplier: 0.5).isActive = true
        infoLabel.widthAnchor.constraint(equalTo: collectionView.widthAnchor, multiplier: 1.0).isActive = true
        infoLabel.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor).isActive = true
        infoLabel.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor).isActive = true
        
        collectionViewRegister()
    }
    
    func setupPlayer(url: URL) {
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        player.rate = PlayerAttributes.playerRate
    }
    
    
    func collectionViewRegister() {
        collectionView.register(TrackCell.self,
                                forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(HeaderReusableView.self,
                                forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                                withReuseIdentifier: headerIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
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
        
        collectionView.collectionViewLayout = layout
        setCollectionView()
    }
    
    fileprivate func setupCollectionView() {
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let newLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            
            setupFlow(flowLayout: flowLayout)
            
            collectionView.collectionViewLayout.invalidateLayout()
            collectionView.layoutIfNeeded()
            setupLayout(layout: newLayout)
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        
        collectionView.backgroundColor = UIColor(red:0.97, green:0.97, blue:0.97, alpha:1.0)
        view.addSubview(collectionView)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBarActive = cancelSearching(searchBar, searchBarActive: searchBarActive)
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBarActive = true
        view.endEditing(true)
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
            return tracks.count - 10
        }
        return 0
    }
    
 }
 
 extension TracksViewController: iTrackDelegate {
    
    func downloadIsComplete(downloaded: Bool) {
        print("DOWNLOADED \(downloaded)")
    }

    
 
    fileprivate func setTrackCell(indexPath: IndexPath?, cell: TrackCell) {
        if let index = indexPath,
            var track = tracks?[index.row] {
            cell.configureWith(track)
            cell.delegate = self
            track.delegate = self
            collections.append(track.collectionName)
            print(track.downloaded)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TrackCell
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
 
 extension TracksViewController: TrackCellDelegate {
    func pauseButtonTapped(tapped: Bool) {
        player.pause()
    }
    
    @objc internal func playButtonTapped(tapped: Bool, download: Download?) {
        if let urlString = download?.url, let url = URL(string: urlString) {
            print(url)
            setupPlayer(url: url)
            player.play()
        }
//        if let url = getLocalURL(from: download) {
//            setupPlayer(url: url)
//            player.play()
//        }
    }
    
    func getLocalURL(from newTrack: Download?) -> URL? {
        if let newTrack = newTrack,
            let url = newTrack.url,
            let localUrl = LocalStorageManager.localFilePathForUrl(url) {
            return localUrl
        }
        return nil
    }
    
    func getDownloadURL(from download: Download?) {
        if let url = download?.url {
            downloads?[url] = download
        }
    }
    
    @objc func download(_ download: Download?) {
        if let store = store {
            store.downloadTrackPreview(for: download)
        }
    }
    
    @objc func downloadButtonTapped(tapped: Bool, download: Download?) {
        if let download = download {
            sendDownloadRequest(download: download)
        }
    }
    
    @objc func sendDownloadRequest(download: Download) {
        self.download(download)
    }
 }
 
 
 extension TracksViewController: UISearchControllerDelegate {

    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBarActive = true
        print("edit")
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBarActive = false
        UIApplication.shared.isStatusBarHidden = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("click")
        searchBarActive = false
    }
    
    fileprivate func noSearchBarInput() {
        infoLabel.isHidden = false
        tracks?.removeAll()
        collectionView.updateLayout(newLayout: small)
    }
    
    func searchBarHasInput() {
        collectionView.backgroundView?.isHidden = true
        tracks?.removeAll()
        infoLabel.isHidden = true
        
        store?.searchForTracks { tracks, error in
            self.tracks = tracks
            DispatchQueue.main.async {
               
                self.collectionView.collectionViewLayout.invalidateLayout()
                self.collectionView.updateLayout(newLayout: self.small)
                self.collectionView.layoutIfNeeded()
                
            }
        }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBarActive = true
        let barText = searchBar.getTextFromBar()
        store = nil
        self.store = iTrackDataStore(searchTerm: barText)
        barText == "" ? noSearchBarInput() : searchBarHasInput()
        navigationController?.navigationBar.topItem?.title = "Search: \(barText)"
        self.searchController.isActive = true
    }
    
    func cancelSearching(_ searchBar: UISearchBar, searchBarActive: Bool) -> Bool {
        print("Cancel")
        return false
    }
 }
 
 extension TracksViewController: UISearchResultsUpdating {
    
    func filterContentForSearchText(searchText: String) {
        print("filter")
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        print("update")
        self.searchController.isActive = true
    }
    
    public func updateSearchResults(for searchController: UISearchController) {
        searchBarActive = true
        
    }
 }
 
 extension TracksViewController: UISearchBarDelegate {
    
    func removeData() {
        downloads?.removeAll()
        tracks?.removeAll()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("Cancel")
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
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        reuseableView.searchBar.delegate = self
        reuseableView.searchBar.barTintColor = .black
    }
 }
