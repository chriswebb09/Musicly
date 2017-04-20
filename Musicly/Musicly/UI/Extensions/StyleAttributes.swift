//
//  GetStyleAttributes.swift
//  Musically
//
//  Created by Christopher Webb-Orenstein on 4/10/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

// TODO: - Cleanup and consolidate

struct CollectionViewConstants {
    static let backgroundColor = UIColor(red: 0.97,
                                         green: 0.97,
                                         blue: 0.97,
                                         alpha: 1.0)
    static let layoutSpacingMinLine: CGFloat = 5.0
    static let layoutSpacingMinItem: CGFloat = 5.0
    static let sectionInsets: UIEdgeInsets = UIEdgeInsets(top: 50.0,
                                                          left: 20.0,
                                                          bottom: 50.0,
                                                          right: 20.0)
    static let rowTimeDivider: Double = 8
    static let defaultItemCount = 50
    static let baseDuration: Double = 0.15
}

struct ApplicationConstants {
    static let mainFont = UIFont(name: "Avenir-Book", size: 18)
    static let fontColor = UIColor(red:0.13, green:0.21, blue:0.44, alpha:1.0)
}

extension UIColor {
    static let appBlue = UIColor(red:0.86, green:0.87, blue:0.90, alpha:1.0)
    static let textColor = UIColor(red:0.13, green:0.21, blue:0.44, alpha:1.0)
    
}

struct EdgeAttributes {
    static let edgeForStandard = UIEdgeInsets(top:80, left: 5, bottom: 5, right: 5)
    static let sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
}

struct SmallLayoutProperties {
    static let minimumInteritemSpacing: CGFloat = 5.0
    static let minimumLineSpacing: CGFloat = 10.0
}

struct MainLayoutProperties {
    
}

struct HeaderViewProperties {
    static let frame = CGRect(x:0 , y:0, width: UIScreen.main.bounds.width, height:50)
}


struct CollectionViewAttributes {
    static let backgroundColor = UIColor(red:0.95, green:0.96, blue:0.98, alpha:1.0)
}

struct PlayerAttributes {
    static let playerRate: Float =  1.0
}

struct NavigationBarAttributes {
    static let navBarTint = UIColor.white
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
