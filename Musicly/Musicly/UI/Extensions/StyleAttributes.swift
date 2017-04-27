//
//  GetStyleAttributes.swift
//  Musically
//
//  Created by Christopher Webb-Orenstein on 4/10/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

// TODO: - Cleanup and consolidate

struct PlayerViewConstants {
    static let backButtonWidthMultiplier: CGFloat = 0.06
    static let backButtonHeightMultiplier: CGFloat = 0.06
    static let backButtonCenterYOffset: CGFloat = -0.08
    static let progressViewWidthMultiplier: CGFloat = 0.6
    static let progressViewHeightMultiplier: CGFloat = 0.01
    static let playTimeLabelHeightMutliplier: CGFloat = 0.25
    static let trackTitleViewHeightMultiplier: CGFloat = 0.08
    static let trackTitleLabelHeightMultiplier: CGFloat = 0.6
    static let trackTitleLabelCenterYOffset: CGFloat =  0.5
    static let artworkViewHeightMultiplier: CGFloat = 0.4
    static let albumWidthMultiplier: CGFloat = 0.5
    static let albumHeightMultiplier: CGFloat = 0.6
    static let preferencedHeightMultiplier: CGFloat = 0.06
    static let thumbsUpLeftOffset: CGFloat = 0.06
    static let artistInfoWidthMultiplier: CGFloat = 0.2
    static let artistInfoHeightMultiplier: CGFloat = 0.7
    static let artistInfoRightOffset: CGFloat = -0.05
    static let thumbsDownLeftOffset: CGFloat = 0.21
    static let controlsViewHeightMultiplier: CGFloat = 0.55
    static let thumbsHeightMultplier: CGFloat = 0.7
    static let thumbsWidthMultiplier: CGFloat = 0.07
}

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
    static let baseDuration: Double = 0.18
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



struct PlaylistViewControllerConstants {
    static let itemSize =  CGSize(width: UIScreen.main.bounds.width, height: 150)
    static let mainColor = UIColor(red:0.13, green:0.21, blue:0.44, alpha:1.0)
    static let backgroundColor = UIColor(red:0.97, green:0.97, blue:0.97, alpha:1.0)
    static let edgeInset = UIEdgeInsets(top:10, left: 0, bottom: 60, right: 0)
    static let collectionViewEdge = UIEdgeInsets(top:0, left: 0, bottom: 60, right: 0)
    static let minimumSpace: CGFloat = 20
    static let collectionItemSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2)
}

struct BasePopConstants {
    static let heightMultiplier: CGFloat = 0.25
}

struct BasePopoverAlertConstants {
    static let popViewX = UIScreen.main.bounds.width / 2
    static let popViewY = UIScreen.main.bounds.height / 2
    static let containerOpacity: Float = 0.4
}

struct SplashConstants {
    static let animationDuration: Double = 0.004
}

public struct LogoConstants {
    public static let logoImageWidth = CGFloat(0.3)
    public static let logoImageHeight = CGFloat(0.1)
    static let startAlpha: CGFloat = 0.7
    static let zoomOutTranform: CGAffineTransform = CGAffineTransform(scaleX: 8, y: 18)
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

struct CALayerConstants {
    static let shadowWidthMultiplier: CGFloat = 0.00001
    static let shadowHeightMultiplier: CGFloat = 0.0002
}

struct TrackCellConstants {
    static let smallFont = UIFont(name: "Avenir-Book", size: 10)
    static let albumHeightMultiplier: CGFloat =  0.86
    static let labelHeightMultiplier: CGFloat = 0.2
}

struct EqualizerConstants {
    static let lineSizeDenominator: CGFloat = 20
    static let xOffsetDenominator: CGFloat =  0.043
    static let yMultiplier: CGFloat = 5.5
    static let pointOffsetMultiplier: CGFloat = 0.8
    static let heightOffsetDenominator: CGFloat = 1.9
    static let xValMultiplier: CGFloat = 1.9
    static let yValMutliplier: CGFloat = 0.45
    static let widthValMultiplier: CGFloat = 2
    static let heightValMultiplier: CGFloat = 0.1
    static let durationMultiplier: Double = 1.1
    static let cornerRadii: CGSize = CGSize(width: 10.0, height: 10.0)
}

struct PlaylistCellConstants {
   // static let nameLabelCenterX = UIScreen.main.bounds.widt
    static let artViewMultiplier: CGFloat = 0.35
    static let artViewWidthMultiplier: CGFloat = 0.7
    static let shadowOffset = CGSize(width: 0, height: 2)
    static let cornerRadius: CGFloat = 2
    static let borderWidth: CGFloat = 1
    static let shadowOpacity: Float = 0.5
    static let mainFont = UIFont(name: "HelveticaNeue", size: 22)!
}

struct DetailPopoverConstants {
    static let cornerRadius: CGFloat = 10
    static let borderWidth: CGFloat = 10
    static let popViewFrameX: CGFloat = UIScreen.main.bounds.width * 0.5
    static let popViewFrameY: CGFloat = UIScreen.main.bounds.height * -0.5
    static let popViewFrameWidth: CGFloat = UIScreen.main.bounds.width * 0.9
    static let popViewFrameHeight: CGFloat = UIScreen.main.bounds.height * 0.55
    static let popViewFrameCenterY: CGFloat = UIScreen.main.bounds.height / 2.5
}

// Constants

struct DetailViewConstants {
    static let heightMultiplier: CGFloat = 0.2
    static let fieldWidth: CGFloat = 0.9
    static let borderWidth: CGFloat = 2
    static let largeCornerRadius: CGFloat = 5
    static let cornerRadius: CGFloat = 2
    static let shadowOpacity: Float = 0.5
    static let shadowOffset = CGSize(width: 0, height: 2)
    static let mainColor: UIColor = UIColor(red:0.13, green:0.21, blue:0.44, alpha:1.0)
    static let titleFont: UIFont = UIFont(name: "Avenir-Book", size: 18)!
}


struct ButtonConstants {
    static let tagBorderWidth: CGFloat = 1
    static let tagBorderCorner: CGFloat = 2
    static let mainFont = UIFont(name: "Avenir-Book", size: 10)!
    static let backgroundColor = UIColor(red:0.41, green:0.72, blue:0.90, alpha:1.0)
    static let systemButtonColor =  UIColor(red:0.13, green:0.21, blue:0.44, alpha:1.0)
}

public struct Tabbar {
    public static let tint = UIColor(red:0.07, green:0.59, blue:1.00, alpha:1.0)
    public static let tabbarFrameHeight: CGFloat = 0.09
}

struct TabbarConstants {
    static let navXYOrigin: CGFloat = 0
    static let navHeightMultiplier: CGFloat = 1.2
}
