//
//  UICollectionView+Extension.swift
//  Musically
//
//  Created by Christopher Webb-Orenstein on 4/10/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

extension UIViewController {
    func setupDefaultUI() {
        let cancelButtonAttributes: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes as? [String : AnyObject], for: UIControlState.normal)
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = .lightGray
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = NSAttributedString(string: "Search for songs...", attributes: [NSForegroundColorAttributeName: UIColor.black])
    }
}

extension UICollectionView {
    
    func getHeader(indexPath: IndexPath, identifier: String) -> HeaderReusableView {
        let reusableView = dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader,
                                                            withReuseIdentifier: identifier,
                                                            for: indexPath) as! HeaderReusableView
        return reusableView
    }
}

extension UICollectionView {
    func updateLayout(newLayout: UICollectionViewLayout) {
        DispatchQueue.main.async {
            self.reloadData()
            self.setCollectionViewLayout(newLayout, animated: true)
        }
    }
}
