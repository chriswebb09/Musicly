//
//  GetStyleAttributes.swift
//  Musically
//
//  Created by Christopher Webb-Orenstein on 4/10/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

struct CollectionViewAttributes {
    static let backgroundColor = UIColor(red:0.95, green:0.96, blue:0.98, alpha:1.0)
}

struct PlayerAttributes {
    static let playerRate: Float =  1.0
}

struct NavigationBarAttributes {
    static let navBarTint = UIColor.white
}


struct BasePopConstants {
    static let heightMultiplier: CGFloat = 0.25
}

enum RowSize {
    case header, track, item, largeLayout, smallLayout
    
    var rawValue: CGSize {
        switch self {
        case .header:
            return CGSize(width: 100, height: 50)
        case .track:
            return CGSize(width: UIScreen.main.bounds.height, height: UIScreen.main.bounds.width / 2)
        case .item:
            return CGSize(width: (UIScreen.main.bounds.size.width - 40)/2.2, height: ((UIScreen.main.bounds.size.width - 40) / 2))
        case .smallLayout:
            return CGSize(width: (UIScreen.main.bounds.size.width - 40)/2.2, height: ((UIScreen.main.bounds.size.width - 40) / 2))
        case .largeLayout:
            return CGSize(width: 150, height: 150)
        }
    }
}
