//
//  TrackCounter.swift
//  Musically
//
//  Created by Christopher Webb-Orenstein on 4/10/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

protocol ItemCounter {
    associatedtype T
    
    func getCount(for items: [T?]) -> Int
}

final class TrackCounter: ItemCounter {
    
    typealias T = iTrack
    
    func getCount(for items: [iTrack?]) -> Int {
        return items.count
    }
}
