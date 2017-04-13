//
//  GetStyleAttributes.swift
//  Musically
//
//  Created by Christopher Webb-Orenstein on 4/10/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

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
    static let navBarTint = UIColor(red:0.79, green:0.79, blue:0.81, alpha:1.0)
}

struct AMCFont {
    fileprivate static let bodyFontName = "AvenirNext-Regular"
    fileprivate static let bodyBoldFontName = "AvenirNext-Medium"
    fileprivate static let largeFontSize = CGFloat(20.0)
    fileprivate static let mediumFontSize = CGFloat(16.0)
    fileprivate static let smallFontSize = CGFloat(14.0)
    fileprivate static let verySmallFontSize = CGFloat(12.0)
    
    static let largeRegular = UIFont(name: bodyFontName, size: largeFontSize)
    static let largeBold = UIFont(name: bodyBoldFontName, size: largeFontSize)
    static let mediumRegular = UIFont(name: bodyFontName, size: mediumFontSize)
    static let mediumBold = UIFont(name: bodyBoldFontName, size: mediumFontSize)
    static let smallRegular = UIFont(name: bodyFontName, size: smallFontSize)
    static let smallBold = UIFont(name: bodyBoldFontName, size: smallFontSize)
    static let verySmallRegular = UIFont(name: bodyFontName, size: verySmallFontSize)
    static let verySmallBold = UIFont(name: bodyBoldFontName, size: verySmallFontSize)
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
