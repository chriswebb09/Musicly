 
 import UIKit
 import RealmSwift
 
 private let reuseIdentifier = "trackCell"
 
 final class TracksViewController: UIViewController {
    
    var dataSource: ListControllerDataSource!
    var buttonItem: UIBarButtonItem!
    
    lazy var collectionView : UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    fileprivate let searchController = UISearchController(searchResultsController: nil)
    
    var emptyView: EmptyView = EmptyView()
    
    fileprivate var searchBar = UISearchBar() {
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let searchBarText = searchBar.text, searchBarText.characters.count > 0 { searchBarActive = true }
    }
    
    func commonInit() {
        buttonItem = UIBarButtonItem(image: dataSource.image,
                                     style: .plain,
                                     target: self,
                                     action: #selector(navigationBarSetup))
        edgesForExtendedLayout = []
        collectionView.isHidden = true
        setupCollectionView()
        navigationItem.setRightBarButton(buttonItem, animated: false)
        setupDefaultUI()
        collectionView.backgroundColor = CollectionViewConstants.backgroundColor
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
    
    private func setupCollectionView() {
        let newLayout: TrackItemsFlowLayout = TrackItemsFlowLayout()
        newLayout.setup()
        collectionView.collectionViewLayout = newLayout
        collectionView.frame = UIScreen.main.bounds
        guard let tabbarHeight = self.tabBarController?.tabBar.frame.height else { return }
        collectionView.contentInset =  UIEdgeInsets(top: 0, left: 0, bottom: tabbarHeight + 20, right: 0)
        view.addSubview(collectionView)
        view.sendSubview(toBack: collectionView)
        view.bringSubview(toFront: emptyView)
        collectionViewRegister(collectionView: collectionView, viewController: self, identifier: reuseIdentifier)
    }
 }
 
 extension TracksViewController: TrackCellCollectionProtocol {
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
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
        return dataSource.playlist.itemCount
    }
 }
 
 extension TracksViewController: TrackCellCreator {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TrackCell
        setTrackCell(indexPath: indexPath, cell: cell, playlist: dataSource.playlist)
        return cell
    }
 }
 
 // MARK: - UICollectionViewDelegate
 
 extension TracksViewController: UICollectionViewDelegate, OpenPlayerProtocol {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destinationViewController = setup(playlist: dataSource.playlist, index: indexPath.row)
        navigationController?.pushViewController(destinationViewController, animated: false)
        
    }
    
 }
 
 // MARK: - UISearchController Delegate
 
 extension TracksViewController: UISearchControllerDelegate {
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        dataSource.playlist.removeAll()
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
            collectionView.reloadData()
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
        collectionView.reloadData()
        dataSource.playlist.removeAll()
        dataSource.store.searchForTracks { [weak self] playlist, error in
            guard let playlist = playlist else { return }
            guard let strongSelf = self else { return }
            strongSelf.dataSource.playlist = playlist
            strongSelf.collectionView.reloadData()
            strongSelf.collectionView.performBatchUpdates ({
                DispatchQueue.main.async {
                    strongSelf.contentState = .results
                    strongSelf.collectionView.reloadItems(at: strongSelf.collectionView.indexPathsForVisibleItems)
                    strongSelf.collectionView.isHidden = false
                }
            }, completion: { finished in
                print(finished)
            })
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let barText = searchBar.text else { return }
        dataSource.store?.setSearch(string: barText)
        searchBarActive = true
        if barText != "" { searchBarHasInput() }
        navigationController?.navigationBar.topItem?.title = "Search: \(barText)"
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
            dataSource.playlist.removeAll()
            if let searchString = searchString {
                self.dataSource.store?.setSearch(string: searchString)
                self.dataSource.store?.searchForTracks { [weak self] tracks, error in
                    guard let strongSelf = self else { return }
                    guard let tracks = tracks else { return }
                    strongSelf.dataSource.playlist = tracks
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
        dataSource.playlist.removeAll()
        contentState = .none
        collectionView.reloadData()
        navigationItem.setRightBarButton(buttonItem, animated: false)
        searchBarActive = false
    }
 }
