//
//  BaseListViewController.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 5/15/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//


import UIKit
import RealmSwift

private let reuseIdentifier = "trackCell"

class BaseListViewController: UIViewController {
    
    var dataSource: ListControllerDataSource!
    
    var contentState: TrackContentState = .none {
        didSet {
            switch contentState {
            case .none:
                self.view.bringSubview(toFront: emptyView)
                print("None")
            case .results:
                self.view.bringSubview(toFront: collectionView)
            case.loaded:
                self.view.bringSubview(toFront: collectionView)
            case .loading:
                return
            }
        }
    }
    
    var emptyView = EmptyView() {
        didSet {
            emptyView.configure()
        }
    }
    
    lazy var collectionView : UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
}

extension BaseListViewController: TrackCellCollectionProtocol {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupEmptyView(emptyView: emptyView, for: view)
        edgesForExtendedLayout = []
        setupCollectionView()
        setupDefaultUI()
        collectionView.backgroundColor = CollectionViewConstants.backgroundColor
        collectionViewRegister(collectionView: collectionView, viewController: self, identifier: reuseIdentifier)
    }
    
    func setupCollectionView() {
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

extension BaseListViewController:  UICollectionViewDataSource  {
    
    @objc(collectionView:cellForItemAtIndexPath:) func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TrackCell
        if let track = dataSource.playlist.playlistItem(at: indexPath.row)?.track, let url = URL(string: track.artworkUrl) {
            let cellViewModel = TrackCellViewModel(trackName: track.trackName, albumImageUrl: url)
            cell.configureCell(with: cellViewModel, withTime: 0)
        }
        let finalFrame = cell.frame
        let translation: CGPoint = collectionView.panGestureRecognizer.translation(in: collectionView.superview)
        if translation.y < 0 { cell.frame = CGRect(x: finalFrame.origin.x, y: 50, width: 0, height: 0) }
        UIView.animate(withDuration: 2.1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [.curveEaseInOut], animations: {
            cell.frame = finalFrame
        }, completion: { finished in
            cell.alpha = 1
        })
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.playlist.itemCount
    }
}
