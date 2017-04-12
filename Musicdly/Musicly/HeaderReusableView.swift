//
//  HeaderReusableView.swift
//  Musically
//
//  Created by Christopher Webb-Orenstein on 4/10/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

class HeaderReusableView: UICollectionReusableView {
    
    var searchBar: UISearchBar!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(searchBar)
    }
    
}
