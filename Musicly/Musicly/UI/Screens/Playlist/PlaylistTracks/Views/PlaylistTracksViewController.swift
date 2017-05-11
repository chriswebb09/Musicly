//
//  PlaylistViewController.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 4/26/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit
import RealmSwift

protocol TrackCellCollectionProtocol {
    func collectionViewRegister(collectionView: UICollectionView, viewController: UIViewController, identifier: String)
}

extension TrackCellCollectionProtocol {
    func collectionViewRegister(collectionView: UICollectionView, viewController: UIViewController, identifier: String) {
        collectionView.register(TrackCell.self, forCellWithReuseIdentifier: identifier)
        collectionView.dataSource = viewController as? UICollectionViewDataSource
        collectionView.delegate = viewController as? UICollectionViewDelegate
    }
}

private let reuseIdentifier = "trackCell"

final class PlaylistViewController: UIViewController {
    
    var emptyView = EmptyView() {
        didSet {
            emptyView.configure()
        }
    }
    
    var dataSource: TracksPlaylistDataSource! {
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
    
    var viewState: ViewState = .showEmptyView {
        didSet {
            switch viewState {
            case .showEmptyView:
                view.bringSubview(toFront: emptyView)
            case.showCollectionView:
                view.bringSubview(toFront: collectionView!)
            }
        }
    }
    
    var buttonItem: UIBarButtonItem?
    
    var collectionView : UICollectionView? = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dump(dataSource.playlist)
        dump(dataSource.tracklist)
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        title = dataSource.title
        commonInit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.rightBarButtonItems = [buttonItem!]
    }
    
    private func commonInit() {
        setupEmptyView(emptyView: emptyView, for: view)
        buttonItem = UIBarButtonItem(image: dataSource.image, style: .plain, target: self, action: #selector(goToSearch))
        edgesForExtendedLayout = []
        setupCollectionView(newLayout: PlaylistItemLayout())
        navigationItem.setRightBarButton(buttonItem, animated: false)
        setupDefaultUI()
        collectionViewRegister(collectionView: collectionView!, viewController: self, identifier: reuseIdentifier)
    }
    
    func goToSearch() {
        let tabController = tabBarController as! TabBarController
        tabController.selectedIndex = 0
        let navController = tabController.viewControllers?[0] as! UINavigationController
        let controller = navController.viewControllers[0] as! TracksViewController
        controller.navigationBarSetup()
    }
    
    private func setupCollectionView(newLayout: PlaylistItemLayout) {
        newLayout.setup()
        collectionView?.collectionViewLayout = newLayout
        collectionView?.frame = UIScreen.main.bounds
        view.backgroundColor = CollectionViewAttributes.backgroundColor
        collectionView?.backgroundColor = CollectionViewConstants.backgroundColor
        if let collectionView = collectionView { view.addSubview(collectionView) }
    }
}

// MARK: - UICollectionViewDataSource
extension PlaylistViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
}

extension PlaylistViewController: TrackCellCollectionProtocol {
    
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
        dataSource.setTrackCell(indexPath: indexPath, cell: cell)
        let finalFrame = cell.frame
        let translation: CGPoint = collectionView.panGestureRecognizer.translation(in: collectionView.superview)
        if translation.y < 0 { cell.frame = CGRect(x: finalFrame.origin.x, y: 50, width: 0, height: 0) }
        cellAnimation(cell: cell, finalFrame: finalFrame)
        return cell
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
extension PlaylistViewController: UICollectionViewDelegate, EmptyViewProtocol {
    
}

