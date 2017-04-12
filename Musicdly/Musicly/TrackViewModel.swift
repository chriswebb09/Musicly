//
//  TrackViewModel.swift
//  Musically
//
//  Created by Christopher Webb-Orenstein on 4/11/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation

protocol TrackViewModel {
    var playButtonEnabled: Bool { get set }
    func enableButton(enabled: Bool) -> Bool
}

struct TrackCellViewModel: TrackViewModel {
    var track: iTrack
    var playButtonEnabled: Bool
    
    init(track: iTrack, playButtonEnabled: Bool) {
        self.track = track
        self.playButtonEnabled = playButtonEnabled
    }
    
    func enableButton(enabled: Bool) -> Bool {
        return !enabled
    }
}

