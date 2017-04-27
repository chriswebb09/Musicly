//
//  UICollectionView+Extension.swift
//  Musically
//
//  Created by Christopher Webb-Orenstein on 4/10/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    func register<T: UICollectionViewCell>(_: T.Type) where T: Reusable {
        register(T.self, forCellWithReuseIdentifier: NSStringFromClass(T.self))
    }
    
    func setupDefaultUI() {
        let cancelButtonAttributes: NSDictionary = [NSForegroundColorAttributeName: UIColor.textColor]
        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes as? [String : AnyObject], for: .normal)
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.textColor
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = NSAttributedString(string: "Search for tracks...", attributes: [NSForegroundColorAttributeName: UIColor.white])
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = .white
        
    }
    
    func setupCollectionView() {
        setupDefaultUI()
        
        backgroundColor = CollectionViewConstants.backgroundColor
        setupLayout()
    }
    
    func setupMusicIcon(icon: UIView) {
        addSubview(icon)
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.35).isActive = true
        icon.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5).isActive = true
        icon.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        icon.centerYAnchor.constraint(equalTo: centerYAnchor, constant: UIScreen.main.bounds.height * -0.13).isActive = true
    }
    
    func setupInfoLabel(infoLabel: UILabel) {
        addSubview(infoLabel)
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
        infoLabel.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        infoLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        infoLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: UIScreen.main.bounds.height * 0.02).isActive = true
    }
    
    static func setupCollectionView() -> UICollectionView {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: layout)
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .vertical
            flowLayout.minimumLineSpacing = 1
        }
        
        collectionView.collectionViewLayout.invalidateLayout()
        layout.sectionInset = PlaylistViewControllerConstants.edgeInset
        layout.itemSize = PlaylistViewControllerConstants.itemSize
        
        return collectionView
    }
    
    static func setupPlaylistCollectionView() -> UICollectionView {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: layout)
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .vertical
            flowLayout.minimumLineSpacing = 10
        }
        
        //collectionView.collectionViewLayout.invalidateLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        //PlaylistViewControllerConstants.edgeInset
        layout.itemSize = PlaylistViewControllerConstants.itemSize
        
        return collectionView
    }
    
    func setupCollection() {
        if let flowLayout = self.collectionViewLayout as? UICollectionViewFlowLayout {
            let newLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout.setupLayout()
            flowLayout.scrollDirection = .vertical
            self.layoutIfNeeded()
            self.collectionViewLayout = newLayout
            //  view.backgroundColor = CollectionViewAttributes.backgroundColor
            self.frame = UIScreen.main.bounds
        }
    }
    
    
    func setupLayout() {
        self.collectionViewLayout.invalidateLayout()
        self.layoutIfNeeded()
    }
}

//extension UICollectionView {
//    
//    func register<T: UICollectionViewCell>(_: T.Type) where T: Reusable {
//        register(T.self, forCellWithReuseIdentifier: NSStringFromClass(T.self))
//    }
//    
//    func setupMusicIcon(icon: UIView) {
//        addSubview(icon)
//        icon.translatesAutoresizingMaskIntoConstraints = false
//        icon.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.35).isActive = true
//        icon.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5).isActive = true
//        icon.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//        icon.centerYAnchor.constraint(equalTo: centerYAnchor, constant: UIScreen.main.bounds.height * -0.13).isActive = true
//    }
//    
//   func setupInfoLabel(infoLabel: UILabel) {
//        addSubview(infoLabel)
//        infoLabel.translatesAutoresizingMaskIntoConstraints = false
//        infoLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
//        infoLabel.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
//        infoLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//        infoLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: UIScreen.main.bounds.height * 0.02).isActive = true
//    }
//    
//    static func setupCollectionView() -> UICollectionView {
//        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//        let collectionView = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: layout)
//        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//            flowLayout.scrollDirection = .vertical
//            flowLayout.minimumLineSpacing = 5
//        }
//        
//        collectionView.collectionViewLayout.invalidateLayout()
//        layout.sectionInset = PlaylistViewControllerConstants.edgeInset
//        layout.itemSize = PlaylistViewControllerConstants.itemSize
//   
//        return collectionView
//    }
//    
//    fileprivate func setupCollectionView() {
//        if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
//            let newLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout.setupLayout()
//            flowLayout.scrollDirection = .vertical
//            layoutIfNeeded()
//            collectionViewLayout = newLayout
//            backgroundColor = CollectionViewAttributes.backgroundColor
//            frame = UIScreen.main.bounds
//        }
//    }
//    
//    
//    func setuLayout() {
//        self.collectionViewLayout.invalidateLayout()
//        self.layoutIfNeeded()
//    }
//}
