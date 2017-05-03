//
//  CollectionViewConstants.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 5/2/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

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
