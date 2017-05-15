//
//  BaseTracksListController.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 5/15/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//


import UIKit
import RealmSwift

private let reuseIdentifier = "trackCell"

class BaseTracksListViewController: UIViewController {
    
    var emptyView = EmptyView() {
        didSet {
            emptyView.configure()
        }
    }
    
    var dataSource: BaseTrackslistDataSource! {
        didSet {
            switch dataSource.state {
            case .none:
                viewState = .showEmptyView
            case .loading:
                viewState = .showEmptyView
            case .results:
                viewState = .showCollectionView
            case .loaded:
                viewState = .showCollectionView
            }
        }
    }
    
    var store: iTrackDataStore?
    
    //    var dataSource: TracksPlaylistDataSource! {
    //        didSet {
    //            switch dataSource.state {
    //            case .none:
    //                viewState = .showEmptyView
    //            case .loading:
    //                viewState = .showEmptyView
    //            case .results:
    //                viewState = .showCollectionView
    //            case .loaded:
    //                viewState = .showCollectionView
    //            }
    //        }
    //    }
    
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
    
    var viewState: ViewState = .showEmptyView {
        didSet {
            switch viewState {
            case .showEmptyView:
                view.bringSubview(toFront: emptyView)
            case.showCollectionView:
                view.bringSubview(toFront: collectionView)
            }
        }
    }
    
    // var buttonItem: UIBarButtonItem?
    var playlist: Playlist = Playlist()
    lazy var collectionView : UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        view.backgroundColor = .clear
        if let tabController = tabBarController as? TabBarController {
            tabController.store = iTrackDataStore()
            store = tabController.store
        }
        commonInit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //  navigationItem.rightBarButtonItems = [buttonItem!]
    }
    
    private func commonInit() {
        setupEmptyView(emptyView: emptyView, for: view)
        edgesForExtendedLayout = []
        collectionView.backgroundColor = CollectionViewConstants.backgroundColor
        setupCollectionView()
        // setupCollectionView(newLayout: PlaylistItemLayout())
        //   navigationItem.setRightBarButton(buttonItem, animated: false)
        setupDefaultUI()
        collectionViewRegister(collectionView: collectionView, viewController: self, identifier: reuseIdentifier)
    }
    
    private func setupCollectionView() {
        let newLayout: TrackItemsFlowLayout = TrackItemsFlowLayout()
        newLayout.setup()
        setupEmptyView(emptyView: emptyView, for: view)
        collectionView.collectionViewLayout = newLayout
        collectionView.frame = UIScreen.main.bounds
        guard let tabbarHeight = self.tabBarController?.tabBar.frame.height else { return }
        collectionView.contentInset =  UIEdgeInsets(top: 0, left: 0, bottom: tabbarHeight + 20, right: 0)
        view.addSubview(collectionView)
        view.sendSubview(toBack: collectionView)
       // view.bringSubview(toFront: emptyView)
       
    }
    
    //    private func setupCollectionView(newLayout: PlaylistItemLayout) {
    //        newLayout.setup()
    //        collectionView.collectionViewLayout = newLayout
    //        collectionView.frame = UIScreen.main.bounds
    //        view.backgroundColor = CollectionViewAttributes.backgroundColor
    //        collectionView.backgroundColor = CollectionViewConstants.backgroundColor
    //        view.addSubview(collectionView)
    //    }
}

// MARK: - UICollectionViewDataSource
extension BaseTracksListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let source = dataSource, source.playlist.itemCount >= 0 {
            print(source.playlist.itemCount)
          //  guard sourc.playlist.itemCount > 0 else { return 0 }
            return source.playlist.itemCount
        } else {
            print("ZERO COUNT")
            return 0
        }
    }
}

extension BaseTracksListViewController: TrackCellCollectionProtocol {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destinationViewController = PlayerViewController()
        destinationViewController.playList = dataSource.playlist
        destinationViewController.hidesBottomBarWhenPushed = true
        destinationViewController.index = indexPath.row
        destinationViewController.parentIsPlaylist = true
        navigationController?.pushViewController(destinationViewController, animated: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TrackCell
        setTrackCell(indexPath: indexPath, cell: cell)
        let finalFrame = cell.frame
        
        
        let translation: CGPoint = collectionView.panGestureRecognizer.translation(in: collectionView.superview)
        if translation.y < 0 { cell.frame = CGRect(x: finalFrame.origin.x, y: 50, width: 0, height: 0) }
        cellAnimation(cell: cell, finalFrame: finalFrame)
        cell.alpha = 1
        collectionView.backgroundColor = .purple
        return cell
    }
    
    fileprivate func setTrackCell(indexPath: IndexPath?, cell: TrackCell) {
        var rowTime: Double
       // var track: Track
        print(dataSource.playlist.playlistItem(at: indexPath!.row)?.track)
        if let index = indexPath, let track = dataSource.playlist.playlistItem(at: index.row)?.track {
            if index.row > 10 {
                rowTime = (Double(index.row % 10)) / CollectionViewConstants.rowTimeDivider
            } else {
                rowTime = (Double(index.row)) / CollectionViewConstants.rowTimeDivider
            }
            if let url = URL(string: track.artworkUrl) { let viewModel = TrackCellViewModel(trackName: track.trackName, albumImageUrl: url)
                cell.configureCell(with: viewModel, withTime: rowTime)
                print("Rowtime: \(rowTime)")
                UIView.animate(withDuration: rowTime / 10) {
                    cell.alpha = 1
                }
            }
        }
    }
    
    func cellAnimation(cell: TrackCell, finalFrame: CGRect) {
        UIView.animate(withDuration: 2.1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [.curveEaseInOut], animations: {
            cell.frame = finalFrame
        }, completion: { finished in
            cell.alpha = 1
        })
    }
}


// MARK: - UICollectionViewDelegate
extension BaseTracksListViewController: UICollectionViewDelegate, EmptyViewProtocol {
    
}
