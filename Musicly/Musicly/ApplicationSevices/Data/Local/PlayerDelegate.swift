//
//  PlayerDelegate.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 5/2/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation

protocol TrackPlayerDelegate: class {
    func updateProgress(progress: Double)
    func trackDurationCalculated(stringTime: String, timeValue: Float64)
    func trackFinishedPlaying()
}


